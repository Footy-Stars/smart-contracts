// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MatchMaking {
	uint256 public matchId;

	mapping(uint256 => MatchDetail) public matchDetail;
	mapping(address => uint256[]) public myMatches;

	struct MatchDetail {
		address player1;
		address player2;
		bool waiting;
		bool started;
	}

	constructor() {}

	function requestMatch() external {
		matchDetail[matchId] = MatchDetail(msg.sender, address(0), true, false);
		myMatches[msg.sender].push(matchId);
		matchId++;
	}

	function getMatchDetail(uint256 _id) external view returns (MatchDetail memory) {
		return matchDetail[_id];
	}

	function getMatches(address _player) external view returns (uint256[] memory) {
		return myMatches[_player];
	}
}