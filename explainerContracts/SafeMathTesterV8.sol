// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SafeMathTesterV8{
    uint8 public  bigNumber=255;//checked
    function add()public {
       unchecked{bigNumber=bigNumber+2;} //if we dont use unchecked then we dont able plus 2 it will show 255 as it is
    }
}