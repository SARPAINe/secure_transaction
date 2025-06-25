// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MinimalERC20} from "../src/MinimalERC20.sol";
import {PrivateTransfer} from "../src/PrivateTransfer.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IERC20} from "../src/IERC20.sol";

contract Deposit is Script {
    MinimalERC20 public minimalERC20;
    PrivateTransfer public privateTransfer;

    function run() public {
        vm.startBroadcast();

        // Assuming the contracts are already deployed
        minimalERC20 = MinimalERC20(0xD0D10Ee4D177d402dC1d48C99633b8A055297f73);
        privateTransfer = PrivateTransfer(
            0xfDE4F040b09fe47f7E5FA4E8948167907B0243Cf
        );

        // Example interaction: Deposit tokens
        bytes32 secret = keccak256(abi.encodePacked("secret2"));
        bytes32 commitment = keccak256(abi.encodePacked(secret));
        uint256 amount = 100 * 10 ** 18; // 100 tokens with 18 decimals
        minimalERC20.approve(address(privateTransfer), amount);
        privateTransfer.deposit(commitment, amount);

        // Example interaction: Withdraw tokens
        // bytes32 secret = "secret";
        // address recipient = msg.sender;
        // privateTransfer.withdraw(secret, recipient, amount);

        vm.stopBroadcast();
    }
}

contract Withdraw is Script {
    PrivateTransfer public privateTransfer;

    function run() public {
        vm.startBroadcast();

        // Assuming the contract is already deployed
        privateTransfer = PrivateTransfer(
            0xfDE4F040b09fe47f7E5FA4E8948167907B0243Cf
        );

        // Example interaction: Withdraw tokens
        bytes32 secret = keccak256(abi.encodePacked("secret2"));
        address recipient = 0x932999C473DEcAFd13722cEB4141239E2753E379;
        uint256 amount = 100 * 10 ** 18; // 100 tokens with 18 decimals
        privateTransfer.withdraw(secret, recipient, amount);

        vm.stopBroadcast();
    }
}

contract FullTransaction is Script {
    MinimalERC20 public minimalERC20;
    PrivateTransfer public privateTransfer;

    function run() public {
        vm.startBroadcast();

        // Assuming the contracts are already deployed
        minimalERC20 = MinimalERC20(0xD0D10Ee4D177d402dC1d48C99633b8A055297f73);
        privateTransfer = PrivateTransfer(
            0xfDE4F040b09fe47f7E5FA4E8948167907B0243Cf
        );

        // Example interaction: Deposit tokens
        bytes32 secret = keccak256(abi.encodePacked("secret3"));
        bytes32 commitment = keccak256(abi.encodePacked(secret));
        uint256 amount = 100 * 10 ** 18; // 100 tokens with 18 decimals
        minimalERC20.approve(address(privateTransfer), amount);
        privateTransfer.deposit(commitment, amount);

        // Example interaction: Withdraw tokens
        address recipient = 0x932999C473DEcAFd13722cEB4141239E2753E379;
        privateTransfer.withdraw(secret, recipient, amount);

        vm.stopBroadcast();
    }
}
