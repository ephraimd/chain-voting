// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

function random() view returns (uint256) {
    uint256 randomHash = uint256(keccak256(abi.encodePacked(block.timestamp)));
    return randomHash % 1000;
}

contract Cryptography {}
