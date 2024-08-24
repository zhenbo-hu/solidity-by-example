// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";

import {GasSaving} from "../src/GasSaving.sol";

contract GasSavingTest is Test {
    GasSaving public gasSaving;
    uint256[] public testArray = [1, 2, 3, 4, 5, 100];

    function setUp() public {
        gasSaving = new GasSaving();
    }

    function testSumIfEvenAndLessThan99() public {
        gasSaving.sumIfEvenAndLessThan99(testArray);
        assertTrue(true);
    }

    function testSumIfEvenAndLessThan99NoGasSaving() public {
        gasSaving.sumIfEvenAndLessThan99NoGasSaving(testArray);
        assertTrue(true);
    }
}
