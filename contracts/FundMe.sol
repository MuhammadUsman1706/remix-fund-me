// Get funds from users
// WIthdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// Remix is smart, and knows this is reference to npm package
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUsd = 50;

    function fund() public payable {
        // We'll send ethereum through the value parameter. Every tranasction, including through MetaMask populates this value field. It can be wei, gwei and ethereum.
        // anyone can fund, so public and payable so it can be sent ethereum
        // like wallets, contract addresses can hold fund as well

        // require is a built in checker, that runs if passed else revert with error msg
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough!"); // 1e18 = 1 * 10^18 wei i.e. 1 ether

        // reverting undoes any action done, and then sends the remianing gas back
    }

    function getPrice() public view returns (uint256) {
        // To interact with the SC (smart contract) we'll need two things, ABI and address
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI is information about the contract, i.e. it's functions and variables, etc, like a TS interface!

        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );

        // int because it can be negative too
        (, int256 price, , , ) = priceFeed.latestRoundData();

        // it returns usd with 8 extra decimals, like 3000_00000000, so we need to align it with 1e18, so multipy with 1e10 so 1e8 * 1e10 = 1e18.
        return uint256(price * 1e10);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();

        // Always multiply first
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}

// A blockchain by itself, cannot communicate with outer world or data. It cannot interact with even another system, like an AI system. It cannot call an API because data would be differnt for different users and it wouldn't be able to reach consensus that way, plus the API would be "centralized". This is where blockchain oracle comes into play.

// Blockchain Oracle: Any device that interacts with the off-chain world to provide external data or computation to smart contracts. Chainlink Data feed is an example of it.

// Data Feed: A network of chainlink nodes gets data from different exchanges and data providers and brings that data through decentralized chainlink nodes. The chainlinks then decide what the actual price of the asset is and then delivers that to a reference "contract" that other smart contracts can use! For example: https://data.chain.link

// Each chain link node gets information about an asset (from different sources) and then signs it with their own private keys and passes it on until one of them (final) delivers it to the reference contract with all the signatures.
