// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;


function itoa(uint integer) pure returns(string memory){
    return string(abi.encode(integer));
}
