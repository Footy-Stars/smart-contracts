// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FootballPlayer.sol";

contract PlayerConfig {

	mapping(address => uint256[5]) public lineup;
	mapping(address => Tatic) public tatic;

	struct Tatic {
		string defStyle;
		string defDepth;
		string defWidth;
		string offChanceCreation;
		string offSpeed;
		string offWidth;
	}

	event ChangeLineup(address player, uint256[5] lineup, Tatic tatic);

	constructor() {}

	function setLineupTatic(uint256[5] calldata _lineup, Tatic calldata _tatic) external {
		// TO DO: ownership check
		for (uint i; i < lineup[msg.sender].length; i++) {
			lineup[msg.sender][i] = _lineup[i];
		}
		tatic[msg.sender] = Tatic(
			_tatic.defStyle,
			_tatic.defDepth,
			_tatic.defWidth,
			_tatic.offChanceCreation,
			_tatic.offSpeed,
			_tatic.offWidth
		);
		emit ChangeLineup(msg.sender, lineup[msg.sender], tatic[msg.sender]);
	}

	function getLineup(address _addr) external view returns (uint256[5] memory) {
		return lineup[_addr];
	}

	function getTatic(address _addr) external view returns (Tatic memory) {
		return tatic[_addr];
	}
}