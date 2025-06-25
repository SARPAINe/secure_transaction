pragma circom 2.0.0;

include "circomlib/poseidon.circom";
include "circomlib/MerkleProof.circom";

template Withdraw(nLevels) {
    signal input root;
    signal input nullifierHash;
    signal input recipient;
    signal input relayer;
    signal input fee;

    signal input nullifier;
    signal input secret;
    signal input pathElements[nLevels];
    signal input pathIndices[nLevels];

    // 1. Calculate commitment = Poseidon(nullifier, secret)
    component hasher = Poseidon(2);
    hasher.inputs[0] <== nullifier;
    hasher.inputs[1] <== secret;
    signal commitment <== hasher.out;

    // 2. Merkle proof of inclusion
    component tree = MerkleProof(nLevels);
    for (var i = 0; i < nLevels; i++) {
        tree.pathElements[i] <== pathElements[i];
        tree.pathIndices[i] <== pathIndices[i];
    }
    tree.leaf <== commitment;
    signal merkleRoot <== tree.root;
    root === merkleRoot;

    // 3. Output nullifier hash = Poseidon(nullifier)
    component nullHash = Poseidon(1);
    nullHash.inputs[0] <== nullifier;
    nullifierHash === nullHash.out;
}

component main = Withdraw(20);
