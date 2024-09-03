//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { simpleWallet } from "src/simpleWallet.sol";
import { deploySimpleWallet } from "script/deploySimpleWallet.s.sol";
import { Test } from "forge-std/Test.sol";

contract testSimpleWallet is Test {
    //Declare 
    simpleWallet wallet;
    deploySimpleWallet public deployer;
    
    //Define test addresses
    address Tester = makeAddr("Tester");
    address Tester2 = makeAddr("Tester2");
    
    //Deploy 
    function setUp() public {
      deployer = new deploySimpleWallet();
      wallet = deployer.run();

    }

    function testSimpleWalletDeposit() public {
      //Test that a user can make a deposit
      //Start the prank, deal and deposit into the contract
      vm.startPrank(Tester);
      vm.deal(Tester, 10 ether);
      uint256 initialContractBalance = address(wallet).balance;
      wallet.deposit{value: 2 ether}();
      uint256 finalContractBalance = address(wallet).balance;
      //Assert that the contract has increased in balance
      assertEq(finalContractBalance, initialContractBalance + 2 ether);
      vm.stopPrank();
    }

    function testSimpleWalletWithdraw() public {
      // Check that a user can withdraw
      // Deal, deposit and withdraw 
      vm.startPrank(Tester);
      vm.deal(Tester, 3 ether);
      wallet.deposit{value: 2 ether}();
      uint initialTesterBalance = Tester.balance;
      wallet.withdraw();
      uint finalContractBalance = address(wallet).balance;
      uint finalTesterBalance = Tester.balance;
      vm.stopPrank();
      // Assert the user could withdraw and the contract balance has decreased
      assertEq(finalContractBalance, 0 ether, "Contract should be empty after withdrawal");
      assertEq(finalTesterBalance, initialTesterBalance + 2 ether, "Tester balance should increase by the withdraw amount");
  }
    function testUnauthorisedAccess() public {
      //Simulate an authorised deposit
      vm.startPrank(Tester);
      vm.deal(Tester, 3 ether);
      wallet.deposit{value: 3 ether}();
      vm.stopPrank();
      
      //Check the contract balance
      uint initialBalance = address(wallet).balance;
      assertEq(initialBalance, 3 ether, "Contract should have 3 ether");

     //User 2 tries to withdraw but isn't authorised
      vm.startPrank(Tester2);
      vm.deal(Tester2, 3 ether);
      vm.expectRevert("Insufficient balance");
      wallet.withdraw();
      vm.stopPrank();

      //Confirm final balance hasn't changed
      uint finalBalance = address(wallet).balance;
      assertEq(finalBalance, 3 ether, "Contract should still have 3 ether as User 2 is unable to withdraw funds");

    } 
}
