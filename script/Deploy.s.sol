// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {MatchMaking} from "../src/MatchMaking.sol";

contract DeployScript is Script {
    MatchMaking mmContract;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // mmContract = new MatchMaking();
        mmContract = MatchMaking(0x41f9D7084f99B68FB5D5a0b5b2e249b577Fe25e2);
        mmContract.quickMatch();

        vm.stopBroadcast();
    }
}
