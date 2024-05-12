// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {QXToken} from "../src/QXToken.sol";
import {console} from "forge-std/console.sol";

contract DeployQXToken is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public ownerPrivateKey;

    function run() external returns (QXToken) {
        if (block.chainid == 31337) {
            ownerPrivateKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            ownerPrivateKey = vm.envUint("PRIVATE_KEY");
        }
        vm.startBroadcast(ownerPrivateKey);
        QXToken qxtoken = new QXToken();
        vm.stopBroadcast();
        return qxtoken;
    }
}
