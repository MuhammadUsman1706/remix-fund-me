// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// What if somebody sends this contract eth directly with address, instead of fund func. We won't have his record as funder anymore!
// To keep this record we can easily use recieve function, called after the contract receives eth
// Runs even if we send 0 wei (lol)
// We can give our function called on transaction in calldata, if not found remix calls fallback function

contract FallbackExample {
    uint256 public result;

    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}
