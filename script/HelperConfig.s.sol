// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PrivateTransfer} from "../src/PrivateTransfer.sol";

abstract contract CodeConstants {
    /* Chain IDs */
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    address public constant SEPOLIA_TETHER_TOKEN_ADDRESS =
        0x7169D38820dfd117C3FA1f22a697dBA58d90BA06; // Tether Token address on Sepolia and Local
    address public constant LOCAL_TETHER_TOKEN_ADDRESS =
        0x7169D38820dfd117C3FA1f22a697dBA58d90BA06; // Tether Token address on Local
}

contract HelperConfig is Script, CodeConstants {
    struct Config {
        address tetherTokenAddress;
        address owner;
        address privateTransferAddress;
    }

    function getConfigByChainId(
        uint256 chainId
    ) public returns (Config memory config) {
        if (chainId == CodeConstants.ETH_SEPOLIA_CHAIN_ID) {
            config.tetherTokenAddress = CodeConstants
                .SEPOLIA_TETHER_TOKEN_ADDRESS; // Sepolia Tether Token
            config.owner = 0xfEc0c677955472E5EcDD3Fb6F3DeeD33D7FB1FB4; // Sepolia Owner
            config.privateTransferAddress = address(
                new PrivateTransfer(CodeConstants.SEPOLIA_TETHER_TOKEN_ADDRESS)
            );
        } else if (chainId == CodeConstants.LOCAL_CHAIN_ID) {
            config.tetherTokenAddress = CodeConstants
                .LOCAL_TETHER_TOKEN_ADDRESS; // Local Tether Token
            config.owner = 0xfEc0c677955472E5EcDD3Fb6F3DeeD33D7FB1FB4; // Local Owner
            config.privateTransferAddress = address(
                new PrivateTransfer(CodeConstants.LOCAL_TETHER_TOKEN_ADDRESS)
            );
        } else {
            revert("Unsupported chain ID");
        }
        return config;
    }
}
