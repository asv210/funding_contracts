// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// whole contract get import from remote github repo of chainlink now we can use any function of that contract
import "./PriceConverter1.sol";

error NotOwner();

contract fundMe{

    using PriceConverter for uint256;
    address public i_owner;

    constructor() {
        i_owner = msg.sender;
    }
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    uint256 public minimumUsd=50 * 10**18;
    function fund() public payable{
        //want to be able to set a minimum fund amount in USD
        require(msg.value.getConversionRate() > minimumUsd,"send enough"); //1e18 =1* 10**18=1eth
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]+=msg.value; 
        //we have to convert to minimumUsd to ether

        //if we reverting now above this line all the command which are executed their gas will get executed others will get reverted.
        //what is reverting?
        //undo any action before,and send remaining gas back
    } 

    function getVersion()public view returns (uint256){
        // ETH/USD price feed address of Sepolia Network
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;// after the if statement the function will be execute if this _; is above if then function will execute first
    }


    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        // there 3 ways to withdraw money
        // // transfer
        //payable -> payable address
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }


    //what if someone sends contract eth without calling the fund function
     // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}