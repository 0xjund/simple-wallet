//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { simpleWallet } from "src/simpleWallet.sol";

contract deploySimpleWallet is Script {
    //Declare, Deploy, Execute
  function run() external returns(simpleWallet) {

    vm.startBroadcast();
    simpleWallet wallet = new simpleWallet();
    vm.stopBroadcast();
    return wallet;
  } 

}
