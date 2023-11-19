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
        mmContract = MatchMaking(0x62125dB2DA783f390CcE30cc354f97c316C62208);
        // mmContract.quickMatch{value: 100}();
        // vm.stopBroadcast();
        // vm.startBroadcast(vm.envUint("PRIVATE_KEY2"));
        // mmContract.quickMatch{value: 100}();
        mmContract.finishMatch(4, 2, 5, 5);
        vm.stopBroadcast();
    }
}
