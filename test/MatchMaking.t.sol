// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MatchMaking} from "../src/MatchMaking.sol";

contract MatchMakingTest is Test {
    MatchMaking public mmContract;

    function setUp() public {
        mmContract = new MatchMaking();
    }

    function testRequest() public{
        mmContract.requestMatch();
        MatchMaking.MatchDetail memory d = mmContract.getMatchDetail(0);
        console2.log("Get match details:");
        console2.log(d.player1);
        console2.log(d.player2);
        console2.log(d.waiting);
        console2.log(d.started);

        console2.log("Current ID count:", mmContract.matchId());

        console2.log(mmContract.myMatches(address(this), 0));
        mmContract.getMatches(address(this));
    }
}
