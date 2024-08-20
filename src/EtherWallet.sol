// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract EtherWallet {
    error NotOwner();
    error InsufficientAmount();

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw(uint256 _amount) external {
        if (msg.sender != owner)
            revert NotOwner();
        
        if (address(this).balance < _amount) 
            revert InsufficientAmount();
        
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}