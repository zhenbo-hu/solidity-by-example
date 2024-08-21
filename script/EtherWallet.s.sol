// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {EtherWallet} from "../src/EtherWallet.sol";

contract EtherWalletScript is Script {
    function run () external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new EtherWallet();

        vm.stopBroadcast();
    }
}