// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MatchMaking {

	uint256 constant SCALE = 100;

	uint256 public matchId;
	uint256 public waitingMatchId; // 1v1 game will instant match if there's one pending
	uint256[6] public wagerPayoffRate;

	mapping(uint256 => MatchDetail) public matchDetail;
	mapping(address => uint256[]) public myMatches;
	mapping(uint256 => mapping(uint256 => WagerResult)) public wagerResult; // finalized wager
	mapping(address => uint256) balance; // balance to withdraw

	enum STATUS {
		NONE,
		WAITING,
		STARTED,
		ENDED
	}

	struct MatchDetail {
		address player1;
		address player2;
		uint256 wager;
		STATUS status;
		uint256 matchWith;
		address winner;
		uint256 winningWager;
		bool is_draw;
	}

	struct WagerResult {
		address player1;
		uint256 amount1;
		address player2;
		uint256 amount2;
	}

	event MatchCreated(uint256 matchId, address player, MatchDetail matchDetail);
	event GameMatched(address player1, address player2, MatchDetail matchDetail1, MatchDetail matchDetail2);
	event WinningResult(uint256 id, MatchDetail matchDetail, WagerResult wagerResult);
	event WinningScore(uint256 id, address winner, uint256 score1, uint256 score2);
	event Withdraw(address to, uint256 amount);

	error UnknownWinner();

	constructor() {
		matchId = 1; // have to reserve 0 for default no match
		wagerPayoffRate[1] = 30; // Initialize wagerPayoffRate, 0 is 0
		wagerPayoffRate[2] = 55;
		wagerPayoffRate[3] = 75;
		wagerPayoffRate[4] = 90;
		wagerPayoffRate[5] = 100;
	}

	// Have to send wager along with the function call
	function quickMatch() external payable {
		require(msg.value != 0, "No wager");
		matchDetail[matchId] = MatchDetail(msg.sender, address(0), msg.value, STATUS.NONE, 0, address(0), 0, false); // init new match

		if (waitingMatchId != 0) _matchGame(matchId);
		else waitingMatchId = matchId;

		myMatches[msg.sender].push(matchId);
		emit MatchCreated(matchId, msg.sender, matchDetail[matchId]);

		matchId++;
	}

	function _matchGame(uint256 _id) private {
		MatchDetail storage m1 = matchDetail[waitingMatchId];
		MatchDetail storage m2 = matchDetail[_id];

		require(m1.wager == m2.wager, "Different wager");
		require(m1.player1 != m2.player1, "Cannot match with self");

		// Player 1 match details (The waiting player)
		m1.player2 = m2.player1;
		m1.status = STATUS.STARTED;
		m1.matchWith = _id;

		// Player 2 match details
		m2.player2 = m1.player1;
		m2.status = STATUS.STARTED;
		m2.matchWith = waitingMatchId;

		// resetting match waiting
		waitingMatchId = 0;

		emit GameMatched(m1.player1, m1.player2, m1, m2);
	}

	/* 
	** @param _winner is either 1 or 2
	*/ 
	function finishMatch(uint256 _id, uint256 _winner, uint256 _score1, uint256 _score2) external {
		// IMPORTANT: verify result proof
		MatchDetail storage m = matchDetail[_id];
		MatchDetail storage m2 = matchDetail[m.matchWith];
		require(m.status == STATUS.STARTED);

		// get winner address
		address winner;
		if (_winner == 1) winner = m.player1;
		else if (_winner == 2) winner = m.player2;
		else revert UnknownWinner();

		m.winner = winner;
		m.status = STATUS.ENDED;
		m2.winner = winner; // repeat for duplicated matchId
		m2.status = STATUS.ENDED;

		// Getting payoff rate
		uint256 rate;
		uint256 scoreDiff;
		if (_score1 > _score2) scoreDiff = _score1 - _score2;
		else scoreDiff = _score2 - _score1;

		if (scoreDiff >= 5) rate = 5;
		else rate = scoreDiff;

		// Reuse memory for rate
		uint256 amount1;
		uint256 amount2;
		rate = wagerPayoffRate[rate];
		if (_winner == 1) {
			amount1 = m.wager + (m.wager * rate * SCALE / SCALE / 100);
			amount2 = m.wager - (m.wager * rate * SCALE / SCALE / 100);
			m.winningWager = amount1;
			m2.winningWager = amount1;
		} else {
			amount1 = m.wager - (m.wager * rate * SCALE / SCALE / 100);
			amount2 = m.wager + (m.wager * rate * SCALE / SCALE / 100);
			m.winningWager = amount2;
			m2.winningWager = amount2;
		}
		wagerResult[_id][m.matchWith] = WagerResult(m.player1, amount1, m.player2, amount2); 
		wagerResult[m.matchWith][_id] = WagerResult(m.player1, amount1, m.player2, amount2); // Repeat for be compatible both way

		if (scoreDiff == 0) {
			m.is_draw = true;
			m2.is_draw = true;
		}

		balance[m.player1] += amount1;
		balance[m.player2] += amount2;
		emit WinningResult(_id, m, wagerResult[_id][m.matchWith]);
		emit WinningScore(_id, m.winner, _score1, _score2);
	}

	function withdraw(address _to) external {
		uint256 amount = balance[_to];
		require(amount != 0, "No balance to withdraw");
		balance[_to] = 0; // setting back to 0

		(bool s, ) = _to.call{value: amount}("");
		require(s, "Failed to withdraw");

		emit Withdraw(_to, amount);
	}

	// ================================================View Functions================================================
	function getMatchDetail(uint256 _id) external view returns (MatchDetail memory) {
		return matchDetail[_id];
	}

	function getMatches(address _player) external view returns (uint256[] memory) {
		return myMatches[_player];
	}
}