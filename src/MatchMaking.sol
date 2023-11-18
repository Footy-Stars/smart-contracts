// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MatchMaking {

	uint256 public matchId;

	// 1v1 game will instand match if there's one pending
	uint256 public waitingMatchId;
	bool public waitingMatch;

	mapping(uint256 => MatchDetail) public matchDetail;
	mapping(address => uint256[]) public myMatches;

	struct MatchDetail {
		address player1;
		address player2;
		bool waiting;
		bool started;
		uint256 matchWith;
		address winner;
	}

	constructor() {
		matchId = 1; // have to reserve 0 for default no match
	}

	function quickMatch() external {
		matchDetail[matchId] = MatchDetail(msg.sender, address(0), true, false, 0, address(0)); 

		if (waitingMatch) {
			_matchGame(matchId);
		} else {
			waitingMatchId = matchId;
			waitingMatch = true;
		}

		myMatches[msg.sender].push(matchId);
		matchId++;
	}

	function _matchGame(uint256 _id) private {
		MatchDetail storage m1 = matchDetail[waitingMatchId];
		MatchDetail storage m2 = matchDetail[_id];

		// Player 1 match details (The waiting player)
		m1.player2 = m2.player1;
		m1.waiting = false;
		m1.started = true;
		m1.matchWith = _id;

		// Player 2 match details
		m2.player2 = m1.player1;
		m2.waiting = false;
		m2.started = true;
		m1.matchWith = waitingMatchId;

		// resetting match waiting
		waitingMatchId = 0;
		waitingMatch = false;
	}

	// ================================================View Functions================================================
	function getMatchDetail(uint256 _id) external view returns (MatchDetail memory) {
		return matchDetail[_id];
	}

	function getMatches(address _player) external view returns (uint256[] memory) {
		return myMatches[_player];
	}
}