// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external;

    function transfer(address to, uint amount) external;
}

contract PrivateTransfer {
    IERC20 public immutable token;

    mapping(bytes32 => bool) public commitments;
    mapping(bytes32 => bool) public nullifiers;

    event Deposit(bytes32 indexed commitment);
    event Withdraw(address to, bytes32 indexed nullifier);

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    /// @notice Deposit tokens with a secret hash (commitment)
    /// @param commitment keccak256(secret)
    /// @param amount token amount to deposit
    function deposit(bytes32 commitment, uint amount) external {
        require(!commitments[commitment], "Already used commitment");

        // Transfer tokens to this contract
        token.transferFrom(msg.sender, address(this), amount);

        // Save commitment
        commitments[commitment] = true;

        emit Deposit(commitment);
    }

    /// @notice Withdraw tokens by revealing the secret
    /// @param secret the original secret (e.g., salt + recipient address + amount)
    /// @param to the address to receive the funds
    /// @param amount the same amount that was deposited
    function withdraw(bytes32 secret, address to, uint amount) external {
        bytes32 commitment = keccak256(abi.encodePacked(secret));
        require(commitments[commitment], "Invalid commitment");

        bytes32 nullifier = keccak256(abi.encodePacked(secret, to, amount));
        require(!nullifiers[nullifier], "Already withdrawn");

        // Mark nullifier as used
        nullifiers[nullifier] = true;

        // Send tokens
        token.transfer(to, amount);

        emit Withdraw(to, nullifier);
    }

    function getTokenAddress() external view returns (address) {
        return address(token);
    }
}
