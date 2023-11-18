// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MatchMaking {

	uint256 constant SCALE = 100;

	uint256 public matchId;
	// 1v1 game will instand match if there's one pending
	uint256 public waitingMatchId;
	bool public waitingMatch;
	uint256[6] public wagerPayoffRate;

	mapping(uint256 => MatchDetail) public matchDetail;
	mapping(address => uint256[]) public myMatches;
	mapping(uint256 => mapping(uint256 => WagerResult)) public wagerResult; // finalized wager

	struct MatchDetail {
		address player1;
		address player2;
		uint256 wager;
		bool waiting;
		bool started;
		uint256 matchWith;
		address winner;
		uint256 winningWager;
	}

	struct WagerResult {
		address player1;
		uint256 amount1;
		address player2;
		uint256 amount2;
	}

	event MatchCreated(uint256 matchId, address player, MatchDetail matchDetail);
	event GameMatched(address player1, address player2, MatchDetail matchDetail1, MatchDetail matchDetail2);
	event WinningResult(uint256 id, address winner, MatchDetail matchDetail, WagerResult wagerResult);

	error UnknownWinner();

	constructor() {
		matchId = 1; // have to reserve 0 for default no match
		// Initialize wagerPayoffRate
		wagerPayoffRate[1] = 30;
		wagerPayoffRate[2] = 55;
		wagerPayoffRate[3] = 75;
		wagerPayoffRate[4] = 90;
		wagerPayoffRate[5] = 100;
	}

	// Have to send wager along with the function call
	function quickMatch() external payable {
		matchDetail[matchId] = MatchDetail(msg.sender, address(0), msg.value, true, false, 0, address(0), 0); // init new match

		if (waitingMatch) {
			_matchGame(matchId);
		} else {
			waitingMatchId = matchId;
			waitingMatch = true;
		}

		myMatches[msg.sender].push(matchId);
		emit MatchCreated(matchId, msg.sender, matchDetail[matchId]);

		matchId++;
	}

	function _matchGame(uint256 _id) private {
		MatchDetail storage m1 = matchDetail[waitingMatchId];
		MatchDetail storage m2 = matchDetail[_id];

		require(m1.wager == m2.wager, "Different wager");

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

		emit GameMatched(m1.player1, m1.player2, m1, m2);
	}

	// @param _winner is either 1 or 2
	function finishMatch(uint256 _id, uint256 _winner, uint256 _scoreDiff) external {
		// IMPORTANT: verify result proof
		MatchDetail storage m = matchDetail[_id];
		require(m.started == true);

		// get winner address
		address winner;
		if (_winner == 1) winner = m.player1;
		else if (_winner == 2) winner = m.player2;
		else revert UnknownWinner();

		m.winner = winner;
		matchDetail[m.matchWith].winner = winner; // repeat for duplicated matchId

		// Getting payoff rate
		uint256 rate;
		if (_scoreDiff >= 5) rate = 5;
		else rate = _scoreDiff;

		// Reuse memory for rate
		uint256 amount1;
		uint256 amount2;
		rate = wagerPayoffRate[rate];
		if (_winner == 1) {
			amount1 = m.wager + (m.wager * rate * SCALE / SCALE / 100);
			amount2 = m.wager - (m.wager * rate * SCALE / SCALE / 100);
			m.winningWager = amount1;
		} else {
			amount1 = m.wager - (m.wager * rate * SCALE / SCALE / 100);
			amount2 = m.wager + (m.wager * rate * SCALE / SCALE / 100);
			m.winningWager = amount2;
		}
		wagerResult[_id][m.matchWith] = WagerResult(m.player1, amount1, m.player2, amount2); 
		wagerResult[m.matchWith][_id] = WagerResult(m.player1, amount1, m.player2, amount2); // Repeat for be compatible both way

		emit WinningResult(_id, m.winner, wagerResult[_id][m.matchWith]);
	}

	// ================================================View Functions================================================
	function getMatchDetail(uint256 _id) external view returns (MatchDetail memory) {
		return matchDetail[_id];
	}

	function getMatches(address _player) external view returns (uint256[] memory) {
		return myMatches[_player];
	}
}