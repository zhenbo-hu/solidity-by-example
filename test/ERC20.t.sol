// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 public erc20;

    function setUp() public {
        erc20 = new ERC20("Token", "TKN", 18);
    }

    function testMintWithSuccessful() public {
        erc20.mint(address(this), 1000);

        assertEq(erc20.balanceOf(address(this)), 1000);
    }

    function testMintWithNotOwner() public {
        vm.prank(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));
        vm.expectRevert(ERC20.notOwner.selector);

        erc20.mint(address(this), 1000);

        assertEq(erc20.balanceOf(address(this)), 0);
    }

    function testBurnWithSuccessful() public {
        erc20.mint(address(this), 1000);

        erc20.burn(address(this), 1000);

        assertEq(erc20.totalSupply(), 0);
    }

    function testBurnWithInsufficientAmount() public {
        erc20.mint(address(this), 1000);
        vm.expectRevert(ERC20.insufficientAmount.selector);

        erc20.burn(address(this), 10000);

        assertEq(erc20.balanceOf(address(this)), 1000);
    }

    function testTransferWithSuccessful() public {
        erc20.mint(address(this), 1000);

        erc20.transfer(
            address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            100
        );

        assertEq(erc20.balanceOf(address(this)), 900);
        assertEq(
            erc20.balanceOf(
                address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
            ),
            100
        );
    }

    function testTransferWithInsufficientAmount() public {
        erc20.mint(address(this), 1000);
        vm.expectRevert(ERC20.insufficientAmount.selector);

        erc20.transfer(
            address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            10000
        );

        assertEq(erc20.balanceOf(address(this)), 1000);
        assertEq(
            erc20.balanceOf(
                address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
            ),
            0
        );
    }

    function testApproveWithSuccessful() public {
        erc20.mint(address(this), 1000);

        erc20.approve(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 500);

        assertEq(
            erc20.allowance(
                address(this),
                address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
            ),
            500
        );
    }

    function testApproveWithInsufficientAmount() public {
        erc20.mint(address(this), 1000);
        vm.expectRevert(ERC20.insufficientAmount.selector);

        erc20.approve(
            address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            5000
        );

        assertEq(
            erc20.allowance(
                address(this),
                address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
            ),
            0
        );
    }

    function testTransferFromWithSuccessful() public {
        erc20.mint(address(this), 1000);
        erc20.approve(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 100);
        vm.prank(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));

        erc20.transferFrom(
            address(this),
            address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8),
            100
        );

        assertEq(
            erc20.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8),
            100
        );
    }

    function testTransferFrom() public {
        erc20.mint(address(this), 1000);
        erc20.approve(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 100);
        vm.prank(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));
        vm.expectRevert(ERC20.insufficientAllowance.selector);

        erc20.transferFrom(
            address(this),
            address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8),
            200
        );

        assertEq(
            erc20.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8),
            0
        );
    }
}
