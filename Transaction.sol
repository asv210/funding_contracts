// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Transactions {
    address private owner;
    uint256 transactionCounts;
    mapping (address => uint) balanceOf;

    // event Transfer(address indexed sender, address indexed receiver, uint256 amount, string remark, uint256 timestamp);

    struct TransferStruct {
        address sender;
        address receiver;
        uint256 amount;
        string remark;
        uint256 timestamp;
    }
    
    TransferStruct[] transactions;

   

    function getOwner() public view returns (address) {
        return msg.sender;
    }

  function sendMoney(address payable receiver,  string memory remark) public payable returns (bool){
        
    
    require(msg.sender.balance >= msg.value, "Insufficient balance");

   

    transactionCounts += 1;
    transactions.push(
        TransferStruct(
            msg.sender,
            receiver,
            msg.value,
            remark,
            block.timestamp
        )
    );
    // payTo(receiver, amount);
            (bool success, ) = receiver.call{value: msg.value}(""); 

    return success;
}

        
    function getBalance(address addr) public view returns(uint) {
        return addr.balance;
    }

    function getAllTransactions() public view returns(TransferStruct[] memory) {
        return transactions;
    }

    function getTransactionsCount() public view returns(uint256) {
        return transactionCounts;
    }
} 
