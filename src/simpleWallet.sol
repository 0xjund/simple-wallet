//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract simpleWallet {

  event Deposit(address indexed sender, uint256 amount);
  event Withdraw( address indexed owner, uint256 amount);

  mapping(address => uint256) public balance; 
  uint256 public required;

  function deposit() external payable {
    balance[msg.sender] += msg.value; 
    emit Deposit(msg.sender, msg.value);
  }
  
  function getContractBalance() public view returns (uint) {
    return address(this).balance;
  }

  function withdraw() external {
    uint256 amount = balance[msg.sender];
    require(amount > 0, "Insufficient balance");
    balance[msg.sender] = 0;
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
    emit Withdraw(msg.sender, amount);
  }

}
