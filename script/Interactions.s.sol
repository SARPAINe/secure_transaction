// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MinimalERC20} from "../src/MinimalERC20.sol";
import {PrivateTransfer} from "../src/PrivateTransfer.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IERC20} from "../src/IERC20.sol";

contract Config {
    address public tokenAddress = 0x3a9DAB65fa437E31ce47FcC80EB9a0d9A170B931;
    address public privateTransferAddress =
        0x80321265E087D94e43619A62b8E78A9e4af8C083;
}

contract Deposit is Script, Config {
    MinimalERC20 public minimalERC20;
    PrivateTransfer public privateTransfer;

    function run() public {
        vm.startBroadcast();

        // Assuming the contracts are already deployed
        minimalERC20 = MinimalERC20(tokenAddress);
        privateTransfer = PrivateTransfer(privateTransferAddress);

        // Example interaction: Deposit tokens
        bytes32 secret = keccak256(abi.encodePacked("secret2"));
        bytes32 commitment = keccak256(abi.encodePacked(secret));
        uint256 amount = 100 * 10 ** 18; // 100 tokens with 18 decimals
        minimalERC20.approve(privateTransferAddress, amount);
        privateTransfer.deposit(commitment, amount);

        vm.stopBroadcast();
    }
}

contract Withdraw is Script, Config {
    PrivateTransfer public privateTransfer;

    function run() public {
        vm.startBroadcast();

        // Assuming the contract is already deployed
        privateTransfer = PrivateTransfer(privateTransferAddress);

        // Example interaction: Withdraw tokens
        bytes32 secret = keccak256(abi.encodePacked("secret2"));
        address recipient = 0x932999C473DEcAFd13722cEB4141239E2753E379;
        privateTransfer.withdraw(secret, recipient);

        vm.stopBroadcast();
    }
}

contract FullTransaction is Script {
    MinimalERC20 public minimalERC20;
    PrivateTransfer public privateTransfer;

    function run() public {
        vm.startBroadcast();

        // Assuming the contracts are already deployed
        minimalERC20 = MinimalERC20(0xEED7bb91770cE1F6B43c662819BE5E8E11e90Fc2);
        privateTransfer = PrivateTransfer(
            0xa0a90e5dBea58d8cAA32C5aa94c03ec73da6E024
        );

        // Example interaction: Deposit tokens
        bytes32 secret = keccak256(abi.encodePacked("secret3"));
        bytes32 commitment = keccak256(abi.encodePacked(secret));
        uint256 amount = 100 * 10 ** 18; // 100 tokens with 18 decimals
        minimalERC20.approve(address(privateTransfer), amount);
        privateTransfer.deposit(commitment, amount);

        // Example interaction: Withdraw tokens
        address recipient = 0x932999C473DEcAFd13722cEB4141239E2753E379;
        privateTransfer.withdraw(secret, recipient);

        vm.stopBroadcast();
    }
}
