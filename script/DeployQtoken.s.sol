// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {Qtoken} from "../src/Qtoken.sol";
import {console} from "forge-std/console.sol";

contract DeployQtoken is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public ownerPrivateKey;

    function run() external returns (Qtoken) {
        if (block.chainid == 31337) {
            ownerPrivateKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            ownerPrivateKey = vm.envUint("PRIVATE_KEY");
        }
        vm.startBroadcast(ownerPrivateKey);
        Qtoken qtoken = new Qtoken();
        vm.stopBroadcast();
        return qtoken;
    }
}
