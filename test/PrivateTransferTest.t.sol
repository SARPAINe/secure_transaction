// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {PrivateTransfer} from "../src/PrivateTransfer.sol";
import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "../src/IERC20.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract PrivateTransferTest is Test, HelperConfig {
    IERC20 public tetherToken;
    PrivateTransfer public privateTransfer;
    address public tetherTokenAddress;
    address public owner;
    address public privateTransferAddress;

    function setUp() public {
        // Set up the test environment
        uint256 chainId = block.chainid;
        HelperConfig.Config memory config = getConfigByChainId(chainId);
        // Deploy the PrivateTransfer contract with a mock token address
        tetherToken = IERC20(config.tetherTokenAddress);
        owner = config.owner;
        privateTransferAddress = config.privateTransferAddress;
        privateTransfer = PrivateTransfer(config.privateTransferAddress);
    }

    function testTetherBalanceIsNotZero() public view {
        // Arrange
        uint256 balance = tetherToken.balanceOf(owner);
        console.log("TetherToken balance of owner:", balance);
        assert(balance > 0);
    }

    function testTransfer() public {
        // Arrange
        // bytes32 commitment = keccak256(abi.encodePacked("secret"));
        uint256 amount = 1000;
        address recipient = 0xD9eC26211A707f9F44350750A213feD1f4D6617B; // Use a different address for recipient
        vm.startPrank(owner);
        uint256 balance = tetherToken.balanceOf(recipient);
        console.log("TetherToken balance of recipient:", balance);
        tetherToken.transfer(recipient, amount);
        uint256 updatedBalance = tetherToken.balanceOf(recipient);
        // console.log("TetherToken balance of recipient:", updatedBalance);
        assert(updatedBalance == amount + balance);
    }

    function testApprove() public {
        // This function approves the transfer of tokens
        uint256 amount = 1000;
        vm.startPrank(owner);
        tetherToken.approve(privateTransferAddress, amount);
        uint256 allowance = tetherToken.allowance(
            owner,
            privateTransferAddress
        );
        console.log("Allowance for PrivateTransfer contract:", allowance);
        assert(allowance == amount);
    }

    function testDeposit() public {
        // This function tests the deposit functionality
        bytes32 commitment = keccak256(abi.encodePacked("secret"));
        uint256 amount = 1000;
        vm.startPrank(owner);
        tetherToken.approve(privateTransferAddress, amount);
        uint256 allowance = tetherToken.allowance(
            owner,
            privateTransferAddress
        );
        console.log("Allowance for PrivateTransfer contract:", allowance);
        privateTransfer.deposit(commitment, amount);
    }

    function testWithdraw() public {
        bytes32 secret = keccak256(abi.encodePacked("secret"));
        bytes32 commitment = keccak256(abi.encodePacked(secret));
        uint256 amount = 10 * 1e6; // Assuming Tether has 6 decimals
        vm.startPrank(owner);
        tetherToken.approve(privateTransferAddress, amount);
        uint256 allowance = tetherToken.allowance(
            owner,
            privateTransferAddress
        );
        console.log("Allowance for PrivateTransfer contract:", allowance);
        privateTransfer.deposit(commitment, amount);

        uint256 contractBalance = tetherToken.balanceOf(privateTransferAddress);
        assert(contractBalance == amount);

        // Withdraw the tokens
        address recipient = 0xD9eC26211A707f9F44350750A213feD1f4D6617B; // Use a different address for recipient
        uint256 recipientBalance = tetherToken.balanceOf(recipient);
        privateTransfer.withdraw(secret, recipient, amount);
        uint256 recipientBalanceAfter = tetherToken.balanceOf(recipient);
        console.log(
            "Recipient balance after withdrawal:",
            recipientBalanceAfter
        );
        assert(recipientBalanceAfter == recipientBalance + amount);
    }
}
