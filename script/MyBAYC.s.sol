// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {MyBAYC} from "../src/MyBAYC.sol";

// address (Amoy Testnet)): 0x4Fc10E40A8308f43DC8b59e9B61f9db7A51a3D59
contract MyBAYCScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new MyBAYC("KH", "KH");

        vm.stopBroadcast();
    }
}
