// Get funds from users
// WIthdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FundMe {
    function fund() public payable {
        // We'll send ethereum through the value parameter. Every tranasction, including through MetaMask populates this value field. It can be wei, gwei and ethereum.
        // anyone can fund, so public and payable so it can be sent ethereum
        // like wallets, contract addresses can hold fund as well

        // require is a built in checker, that runs if passed else revert with error msg
        require(msg.value > 1e18, "Didn't send enough!"); // 1e18 = 1 * 10^18 wei i.e. 1 ether

        // reverting undoes any action done, and then sends the remianing gas back
    }
}
