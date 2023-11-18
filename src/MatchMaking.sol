// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MatchMaking {
	uint256 public matchId;
	uint256 public numPending;
	uint256[] public pendingMatches;

	uint256 private pendingPointer;

	mapping(uint256 => MatchDetail) public matchDetail;
	mapping(address => uint256[]) public myMatches;

	struct MatchDetail {
		address player1;
		address player2;
		bool waiting;
		bool started;
		uint256 matchWith;
	}

	constructor() {}

	function requestMatch() external {
		matchDetail[matchId] = MatchDetail(msg.sender, address(0), true, false, 0); // have to reserve 0 for default no match
		myMatches[msg.sender].push(matchId);

		if (numPending) {
			_matchGame(matchId);
		} else {
			pendingMatches.push(matchId);
			numPending++;
		}

		matchId++;
	}

	function _matchGame(uint256 _id) private {
		if (pendingPointer == pendingMatches.length) pendingPointer = 0;
		MatchDetail storage m1 = matchDetail[pendingMatches[pendingPointer]];
		MatchDetail storage m2 = matchDetail[_id];

		m1 = MatchDetail(m1.player1, m2.player1, false, true, _id);
		m2 = MatchDetail(m2.player1, m1.player1, false, true, pendingMatches[pendingPointer]);

		// remove pending match
		pendingMatches[pendingPointer] = 0;
		pendingPointer++;
	}

	function getMatchDetail(uint256 _id) external view returns (MatchDetail memory) {
		return matchDetail[_id];
	}

	function getMatches(address _player) external view returns (uint256[] memory) {
		return myMatches[_player];
	}
}