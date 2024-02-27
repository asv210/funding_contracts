// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Transactions {
    address private owner;
    uint256 transactionCounts;
    mapping (address => uint) balanceOf;

     address[] private admins;

     constructor(address[] memory _admins){
        admins = _admins;
        id=0;
     }

    // event Transfer(address indexed sender, address indexed receiver, uint256 amount, string remark, uint256 timestamp);

    struct TransferStruct {
        string sender;
        string receiver;
        string amount;
        string remark;
        uint256 timestamp;
        uint id;
    }
    
    TransferStruct[] transactions;
    mapping(uint=>TransferStruct)keyToTransaction;
    uint private id; 

    function getOwner() public view returns (address) {
        return msg.sender;
    }

    modifier authorizeUser{
        bool isAdmin = false;
        for (uint i = 0; i < admins.length; i++) {
            if (msg.sender == admins[i]) {
                isAdmin = true;
                break;
            }
        }

        require(isAdmin, "Unauthorized: Only admins can execute this function");
        _; 

    }

  function sendMoney(string memory sender,string memory receiver,string memory amount,string memory remark) public authorizeUser{

     id+= 1;
     TransferStruct memory transaction=TransferStruct(sender,
            receiver,
            amount,
            remark,
            block.timestamp,
            id);
    transactions.push(
        transaction
    );
    keyToTransaction[id]=transaction;
    }

    function getAllTransactions() public view returns(TransferStruct[] memory) {
        return transactions;
    }

   
    function getTransaction(uint key) public  view returns (TransferStruct memory){
        return keyToTransaction[key];
    }
} 
