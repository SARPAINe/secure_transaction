// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "../src/IERC20.sol";

contract TetherTokenScript is Script {
    IERC20 public tetherToken;
    address public tetherTokenAddress =
        0x7169D38820dfd117C3FA1f22a697dBA58d90BA06; // Replace with actual address
    address public userAddress = 0xfEc0c677955472E5EcDD3Fb6F3DeeD33D7FB1FB4; // Replace with actual user address

    // function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Assign the contract at the deployed address
        tetherToken = IERC20(tetherTokenAddress);

        // Call the balanceOf function
        uint256 balance = tetherToken.balanceOf(userAddress);
        console.log("TetherToken balance:", balance);

        vm.stopBroadcast();
    }
}
