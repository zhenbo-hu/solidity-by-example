// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";

import {ERC721} from "../src/ERC721.sol";

contract ERC721Test is Test {
    ERC721 public erc721;

    function setUp() public {
        erc721 = new ERC721();
    }

    function testMintWithSuccessful() public {
        erc721.mint(address(this));
        uint256 tokenId = erc721.currentTokenId();

        assertTrue(tokenId > 0);
        assertEq(erc721.ownerOf(tokenId), address(this));
        assertEq(erc721.balanceOf(address(this)), 1);
    }

    function testBurnWithSuccessful() public {
        erc721.mint(address(this));
        uint256 tokenId = erc721.currentTokenId();

        erc721.burn(tokenId);

        assertEq(erc721.balanceOf(address(this)), 0);
    }
}
