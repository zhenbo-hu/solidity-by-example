// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC20} from "./library/IERC20.sol";

contract ERC20 is IERC20 {
    error notOwner();
    error insufficientAmount();
    error insufficientAllowance();

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name;
    string public symbol;
    uint8 public immutable DECIMALS;
    address public immutable OWNER;

    modifier onlyOwner() {
        if (msg.sender != OWNER) revert notOwner();
        _;
    }

    modifier effectAmount(address account, uint256 amount) {
        if (balanceOf[account] < amount) revert insufficientAmount();
        _;
    }

    modifier effectAllowance(
        address account1,
        address account2,
        uint256 amount
    ) {
        if (allowance[account1][account2] < amount)
            revert insufficientAllowance();
        _;
    }

    constructor(string memory _name, string memory _symbol, uint8 decimals) {
        name = _name;
        symbol = _symbol;
        DECIMALS = decimals;
        OWNER = msg.sender;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external effectAmount(msg.sender, amount) returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function approve(
        address spender,
        uint256 amount
    ) external effectAmount(msg.sender, amount) returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    )
        external
        effectAmount(sender, amount)
        effectAllowance(sender, msg.sender, amount)
        returns (bool)
    {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(
        address from,
        uint256 amount
    ) external effectAmount(msg.sender, amount) {
        _burn(from, amount);
    }

    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount;
        totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }
}
