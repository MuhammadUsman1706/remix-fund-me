// Get funds from users
// WIthdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // constant keyword uses less gas and is unchangable
    uint256 public constant MINIMUM_USD = 50 * 1e18; // All caps with underscore
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    // variables set only once, but not during declaration can be set immutable
    address public immutable i_owner; // i_vname

    // Immediately invoked upon deploying the contract
    constructor() {
        // Whoever deploys this contract
        i_owner = msg.sender;
    }

    function fund() public payable {
        // We'll send ethereum through the value parameter. Every tranasction, including through MetaMask populates this value field. It can be wei, gwei and ethereum.
        // anyone can fund, so public and payable so it can be sent ethereum
        // like wallets, contract addresses can hold fund as well

        // require is a built in checker, that runs if passed else revert with error msg
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "Didn't send enough!"
        ); // 1e18 = 1 * 10^18 wei i.e. 1 ether
        funders.push(msg.sender); // wallet address
        addressToAmountFunded[msg.sender] = msg.value;

        // reverting undoes any action done, and then sends the remaining gas back
    }

    // the modifier runs before any withdraw
    function withdraw() public onlyOwner {
        // After withdrawal, we clear the amount paid by any funder. (Awain)
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            addressToAmountFunded[funders[funderIndex]] = 0;
        }

        funders = new address[](0); // (0) => starts with 0 elements

        // Three ways to withdraw funds
        // Transfer, send and call
        // https://solidity-by-example.org/sending-ether/

        // Transfer the amount to the sender of 'this' contract (address)
        // msg.sender = address, payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance); // reverts on faliure

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance); // returns bool on faliure
        // require(sendSuccess, "Send Failed!");

        // call, if we provide a function, it will provide data from the function we pass in it (not here) in second return value
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }(""); // returns two variables
        require(callSuccess, "Call Failed!");
    }

    // Performs it's functions and then renders the main function at '_'
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Access Denied");

        // this helps save gas because we don't have to store a long string faliure message i.e. an array of chars
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

}

// A blockchain by itself, cannot communicate with outer world or data. It cannot interact with even another system, like an AI system. It cannot call an API because data would be differnt for different users and it wouldn't be able to reach consensus that way, plus the API would be "centralized". This is where blockchain oracle comes into play.

// Blockchain Oracle: Any device that interacts with the off-chain world to provide external data or computation to smart contracts. Chainlink Data feed is an example of it.

// Data Feed: A network of chainlink nodes gets data from different exchanges and data providers and brings that data through decentralized chainlink nodes. The chainlinks then decide what the actual price of the asset is and then delivers that to a reference "contract" that other smart contracts can use! For example: https://data.chain.link

// Each chain link node gets information about an asset (from different sources) and then signs it with their own private keys and passes it on until one of them (final) delivers it to the reference contract with all the signatures.

// Gas Efficiency:
// Variables: constant and immutables
