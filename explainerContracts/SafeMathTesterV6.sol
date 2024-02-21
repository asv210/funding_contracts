// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
contract SafeMathTesterV6{
    uint8 public bigNumber=255;//unchecked
    function add() public {
        bigNumber=bigNumber+1; //it is already unchecked but showing output as 0
    }
}   