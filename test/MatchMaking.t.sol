// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MatchMaking} from "../src/MatchMaking.sol";

contract MatchMakingTest is Test {
    MatchMaking public mmContract;

    function setUp() public {
        mmContract = new MatchMaking();
    }

    function testQuickMatch() public {
        mmContract.quickMatch{value: 100}();

        uint256 cur_id = mmContract.matchId();
        console2.log("Current ID count:", cur_id, "\n");

        MatchMaking.MatchDetail memory d = mmContract.getMatchDetail(
            cur_id - 1
        );
        console2.log("Get match details of id", cur_id - 1);
        console2.log(d.player1);
        console2.log(d.player2);
        console2.log(d.matchWith);
        console2.log(d.winner, "\n");

        vm.prank(vm.addr(1));
        vm.deal(vm.addr(1), 1000000000);
        mmContract.quickMatch{value: 100}();
        cur_id = mmContract.matchId();

        console2.log("Current ID count:", cur_id, "\n");

        d = mmContract.getMatchDetail(cur_id - 1);
        console2.log("Get match details of id", cur_id - 1);
        console2.log(d.player1);
        console2.log(d.player2);
        console2.log(d.matchWith);
        console2.log(d.winner, "\n");
    }

    function testWinner() public {
        testQuickMatch();
        mmContract.finishMatch(1, 1, 8, 4);
    }
}
