// Get funds from users
// WIthdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUsd = 50 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // We'll send ethereum through the value parameter. Every tranasction, including through MetaMask populates this value field. It can be wei, gwei and ethereum.
        // anyone can fund, so public and payable so it can be sent ethereum
        // like wallets, contract addresses can hold fund as well

        // require is a built in checker, that runs if passed else revert with error msg
        require(
            msg.value.getConversionRate() >= minimumUsd,
            "Didn't send enough!"
        ); // 1e18 = 1 * 10^18 wei i.e. 1 ether
        funders.push(msg.sender); // wallet address
        addressToAmountFunded[msg.sender] = msg.value;

        // reverting undoes any action done, and then sends the remaining gas back
    }
}

// A blockchain by itself, cannot communicate with outer world or data. It cannot interact with even another system, like an AI system. It cannot call an API because data would be differnt for different users and it wouldn't be able to reach consensus that way, plus the API would be "centralized". This is where blockchain oracle comes into play.

// Blockchain Oracle: Any device that interacts with the off-chain world to provide external data or computation to smart contracts. Chainlink Data feed is an example of it.

// Data Feed: A network of chainlink nodes gets data from different exchanges and data providers and brings that data through decentralized chainlink nodes. The chainlinks then decide what the actual price of the asset is and then delivers that to a reference "contract" that other smart contracts can use! For example: https://data.chain.link

// Each chain link node gets information about an asset (from different sources) and then signs it with their own private keys and passes it on until one of them (final) delivers it to the reference contract with all the signatures.
