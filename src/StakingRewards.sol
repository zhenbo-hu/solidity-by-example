// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC20} from "./library/IERC20.sol";

contract StakingRewards {
    error NotOwner();
    error ZeroAmount();
    error RewardDurationNotFinished();
    error ZeroRewardRate();
    error InsufficientRewardAmount();

    IERC20 public immutable STAKING_TOKEN;
    IERC20 public immutable REWARDS_TOKEN;

    address public immutable OWNER;

    // Duration of rewards to be paid out (in seconds)
    uint256 public duration;
    // Timestamp of when the rewards finish
    uint256 public finishAt;
    // Minimum of last updated time and reward finish time
    uint256 public updatedAt;
    // Reward to be paid out per second
    uint256 public rewardRate;
    // Sum of (reward rate * dt * 1e18 / total supply)
    uint256 public rewardPerTokenStored;
    // User address => rewardPerTokenStored
    mapping(address => uint256) public userRewardPerTokenPaid;
    // User address => rewards to be claimed
    mapping(address => uint256) public rewards;

    // Total staked
    uint256 public totalSupply;
    // User address => staked amount
    mapping(address => uint256) public balanceOf;

    constructor(address _stakingToken, address _rewardToken) {
        STAKING_TOKEN = IERC20(_stakingToken);
        REWARDS_TOKEN = IERC20(_rewardToken);
        OWNER = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != OWNER) revert NotOwner();
        _;
    }

    // 根据最新的时间，更新该地址的reward
    modifier updateReward(address _account) {
        rewardPerTokenStored = rewardPerToken();
        updatedAt = lastTimeRewardApplicable();

        if (_account != address(0)) {
            rewards[_account] = earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }

        _;
    }

    modifier zeroAmount(uint256 _amount) {
        if (_amount == 0) revert ZeroAmount();
        _;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return _min(finishAt, block.timestamp);
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) return rewardPerTokenStored;

        return
            rewardPerTokenStored +
            (rewardRate * (lastTimeRewardApplicable() - updatedAt) * 1e18) /
            totalSupply;
    }

    function stake(
        uint256 _amount
    ) external updateReward(msg.sender) zeroAmount(_amount) {
        STAKING_TOKEN.transferFrom(msg.sender, address(this), _amount);
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;
    }

    function withdraw(
        uint256 _amount
    ) external updateReward(msg.sender) zeroAmount(_amount) {
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        STAKING_TOKEN.transfer(msg.sender, _amount);
    }

    function earned(address _account) public view returns (uint256) {
        return
            ((balanceOf[_account] *
                (rewardPerToken() - userRewardPerTokenPaid[_account])) / 1e18) +
            rewards[_account];
    }

    function getReward() external updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            REWARDS_TOKEN.transfer(msg.sender, reward);
        }
    }

    function setRewardsDuration(uint256 _duration) external onlyOwner {
        if (finishAt >= block.timestamp) revert RewardDurationNotFinished();

        duration = _duration;
    }

    function notifyRewardAmount(
        uint256 _amount
    ) external onlyOwner updateReward(address(0)) {
        if (block.timestamp >= finishAt) {
            rewardRate = _amount / duration;
        } else {
            uint256 remainingRewards = (finishAt - block.timestamp) *
                rewardRate;
            rewardRate = (_amount + remainingRewards) / duration;
        }

        if (rewardRate == 0) revert ZeroRewardRate();
        if (rewardRate * duration > REWARDS_TOKEN.balanceOf(address(this)))
            revert InsufficientRewardAmount();

        finishAt = block.timestamp + duration;
        updatedAt = block.timestamp;
    }

    function _min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }
}
