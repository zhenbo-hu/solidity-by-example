// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";

import {MyBAYC} from "../src/MyBAYC.sol";

contract MyBAYCTest is Test {
    string public constant TOKEN_URI =
        "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq";
    MyBAYC public myBayc;

    function setUp() public {
        myBayc = new MyBAYC("KH", "KH");
    }

    function testMintWithSuccessful() public {
        myBayc.mint(address(this), 0);

        assertEq(myBayc.ownerOf(0), address(this));
        assertEq(myBayc.tokenURI(0), string.concat(TOKEN_URI, "/0"));
        assertEq(myBayc.balanceOf(address(this)), 1);
    }

    function testMintWithTokenIdOutOfRange() public {
        vm.expectRevert(MyBAYC.TokenIdOutOfRange.selector);
        myBayc.mint(address(this), 10001);
    }
}
