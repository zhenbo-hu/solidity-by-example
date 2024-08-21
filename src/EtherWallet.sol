// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract EtherWallet {
    error NotOwner();
    error InsufficientAmount();

    address payable public immutable OWNER;

    constructor() {
        OWNER = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw(uint256 amount_) external {
        if (msg.sender != OWNER) revert NotOwner();

        if (address(this).balance < amount_) revert InsufficientAmount();

        payable(msg.sender).transfer(amount_);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
