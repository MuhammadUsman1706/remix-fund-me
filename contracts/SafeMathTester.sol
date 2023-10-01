// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract SafeMathTester{
    // before solidity 0.8.0, numbers were "unchecked", which means if they get out of range, they will start from beginning
    // to prevent that, safemath library was used, which warned before this happened. But solidity 0.8.0 changed this behaviour and numbers are now "checked".

    // 255 is limit, so adding 1 gets it to 0
    uint8 public bigNumber = 255;

    // to uncheck in 0.8.0 and above
    // unchecked {uint8 public bigNumber = 255;}

}