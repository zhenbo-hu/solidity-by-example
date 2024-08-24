// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract GasSaving {
    uint256 public total;

    // Input: [1, 2, 3, 4, 5, 100]

    // gas optimized
    // gas: 47407
    function sumIfEvenAndLessThan99(uint256[] calldata nums) external {
        uint256 _total = total;
        uint256 len = nums.length;

        for (uint256 i; i < len; ) {
            uint256 num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
            unchecked {
                ++i;
            }
        }

        total = _total;
    }

    // not gas optimized
    // gas: 49264
    function sumIfEvenAndLessThan99NoGasSaving(uint[] memory nums) external {
        for (uint i = 0; i < nums.length; i += 1) {
            bool isEven = nums[i] % 2 == 0;
            bool isLessThan99 = nums[i] < 99;
            if (isEven && isLessThan99) {
                total += nums[i];
            }
        }
    }
}
