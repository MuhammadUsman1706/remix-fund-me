// A library that we're going to attach to uint256
// Solidity libraries can be used to add member functions to specific data types

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Remix is smart, and knows this is reference to npm package
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Can't have state variables and can't send ether
library PriceConverter {
    function getPrice() internal view returns (uint256) {
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

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );

        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();

        // Always multiply first
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
