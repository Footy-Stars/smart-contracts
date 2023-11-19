// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {PlayerConfig} from "../src/PlayerConfig.sol";

contract PlayerConfigTest is Test {

	PlayerConfig public playerConfig;

    function setUp() public {
		playerConfig = new PlayerConfig();
	}

	function testConfig() public {
		uint256[5] memory lineup;
		PlayerConfig.Tatic memory tatic;

		for (uint i; i < lineup.length; i++) {
			lineup[i] = i;
		}
		tatic = PlayerConfig.Tatic(
			"stringA",
			"stringB",
			"stringC",
			"stringD",
			"stringE",
			"stringF"
		);
		playerConfig.setLineupTatic(lineup, tatic);
		playerConfig.getLineup(address(this));
		playerConfig.getTatic(address(this));
	}
}