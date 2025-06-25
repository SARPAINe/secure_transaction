// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {MinimalERC20} from "../src/MinimalERC20.sol";
import {PrivateTransfer} from "../src/PrivateTransfer.sol";
import {console} from "forge-std/console.sol";

contract DeployMinimaERC20 is Script {
    MinimalERC20 public minimalERC20;
    PrivateTransfer public privateTransfer;
    uint256 public initialSupply = 1000000 * 10 ** 18; // 1 million tokens with 18 decimals

    function run() public {
        vm.startBroadcast();

        minimalERC20 = new MinimalERC20(initialSupply);
        console.log("MinimalERC20 deployed at:", address(minimalERC20));

        privateTransfer = new PrivateTransfer(address(minimalERC20));
        console.log("PrivateTransfer deployed at:", address(privateTransfer));

        vm.stopBroadcast();
    }
}
