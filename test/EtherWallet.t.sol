// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {EtherWallet} from "../src/EtherWallet.sol";

contract EtherWalletTest is Test {
    EtherWallet public etherWallet;

    receive() external payable {}

    function setUp() public {
        etherWallet = new EtherWallet();
    }

    function testOwner() public {
        address payable owner = etherWallet.owner();
        assertEq(owner, address(this));
    }

    function testGetBalance() public {
        assertEq(etherWallet.getBalance(), 0);
    }

    function testReceive() public {
        assertEq(etherWallet.getBalance(), 0);

        payable(address(etherWallet)).transfer(1 ether);

        assertEq(etherWallet.getBalance(), 1 ether);
    }

    function testwithdraw() public {
        payable(address(etherWallet)).transfer(1 ether);
        assertEq(etherWallet.getBalance(), 1 ether);

        etherWallet.withdraw(0.4 ether);
        assertEq(etherWallet.getBalance(), 0.6 ether);
    }

    function testWithdrawWithInsufficientAmount() public {
        payable(address(etherWallet)).transfer(1 ether);
        assertEq(etherWallet.getBalance(), 1 ether);

        vm.expectRevert(EtherWallet.InsufficientAmount.selector);

        etherWallet.withdraw(1.1 ether);
    }

    function testWithdrawWithNotOwner() public {
        payable(address(etherWallet)).transfer(1 ether);
        assertEq(etherWallet.getBalance(), 1 ether);

        vm.prank(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));
        vm.expectRevert(EtherWallet.NotOwner.selector);
        etherWallet.withdraw(0.1 ether);
    }
}