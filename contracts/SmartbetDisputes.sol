/**
 *Submitted for verification at amoy.polygonscan.com on 2024-10-12
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SmartbetContract {
  address public owner;
  uint256 private immutable deploymentId;
  uint256 private constant FEE_PERCENTAGE = 1000;

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  struct Dispute {
    string Name;
    string Wallpaper;
    string Candidate1;
    string CandidateImage1;
    uint256 CandidateBet1;
    string Candidate2;
    string CandidateImage2;
    uint256 CandidateBet2;
    uint8 Winner;
    uint256 NetPrize;
    uint256 Fee;
    bool Status;
  }

  mapping(uint256 => Dispute) public disputes;
  uint256[] private disputeIds;
  uint256 private currentDisputeId;

  struct Bet {
    uint256 disputeId;
    uint8 candidateNumber;
    uint256 amount;
    uint256 collectedAmount;
    bool collected;
  }

  mapping(address => mapping(uint256 => Bet)) private walletBets;
  mapping(address => uint256[]) private walletDisputeIds;

  constructor() {
    owner = msg.sender;
    deploymentId = block.timestamp;
  }

  function createDispute(
    string memory _Name,
    string memory _Wallpaper,
    string memory _Candidate1,
    string memory _CandidateImage1,
    string memory _Candidate2,
    string memory _CandidateImage2
  ) public onlyOwner {
    currentDisputeId++;
    disputes[currentDisputeId] = Dispute({
      Name: _Name,
      Wallpaper: _Wallpaper,
      Candidate1: _Candidate1,
      CandidateImage1: _CandidateImage1,
      Candidate2: _Candidate2,
      CandidateImage2: _CandidateImage2,
      CandidateBet1: 0,
      CandidateBet2: 0,
      Winner: 0,
      NetPrize: 0,
      Fee: 0,
      Status: true
    });
    disputeIds.push(currentDisputeId);
  }

  function getAllDisputeIds() public view returns (uint256[] memory) {
    return (disputeIds);
  }

  function createBet(uint256 _disputeId, uint8 _candidateNumber) public payable {
    require(msg.value > 0, "Bet value must be greater than zero");
    require(disputes[_disputeId].Winner == 0, "Dispute already finished");
    require(walletBets[msg.sender][_disputeId].amount == 0, "Already bet on this dispute");

    Dispute storage dispute = disputes[_disputeId];

    uint256 fee = (msg.value * FEE_PERCENTAGE) / 10000;
    uint256 netBet = msg.value - fee;

    if (_candidateNumber == 1) {
      dispute.CandidateBet1 += netBet;
    } else {
      dispute.CandidateBet2 += netBet;
    }

    dispute.Fee += fee;
    dispute.NetPrize += netBet;

    Bet memory newBet = Bet({
      disputeId: _disputeId,
      candidateNumber: _candidateNumber,
      amount: netBet,
      collected: false,
      collectedAmount: 0
    });

    walletBets[msg.sender][_disputeId] = newBet;
    walletDisputeIds[msg.sender].push(_disputeId);
  }

  function getBetDetails(address _wallet, uint256 _disputeId) public view returns (Bet memory) {
    return walletBets[_wallet][_disputeId];
  }

  function getAllWalletBets(address _wallet) public view returns (uint256[] memory) {
    return walletDisputeIds[_wallet];
  }

  function toggleStatus(uint256 _disputeId, bool _status) public onlyOwner {
    Dispute storage dispute = disputes[_disputeId];
    dispute.Status = _status;
  }

  function finishDispute(uint256 _disputeId, uint8 _winner) public onlyOwner {
    require(disputes[_disputeId].Winner == 0, "Dispute already finished");
    require(_winner == 1 || _winner == 2, "Invalid winner");

    Dispute storage dispute = disputes[_disputeId];
    dispute.Winner = _winner;

    uint256 feeToTransfer = dispute.Fee;
    payable(owner).transfer(feeToTransfer);
  }

  function claimPrize(uint256 _disputeId) public {
    Bet storage bet = walletBets[msg.sender][_disputeId];
    Dispute storage dispute = disputes[_disputeId];

    require(bet.amount > 0, "No bet found");
    require(dispute.Winner != 0, "Dispute not finished");
    require(!bet.collected, "Bet already collected");
    require(bet.candidateNumber == dispute.Winner, "You didn't bet on the winning candidate");

    uint256 winningCandidateBet = dispute.Winner == 1
      ? dispute.CandidateBet1
      : dispute.CandidateBet2;
    uint256 losingCandidateBet = dispute.Winner == 1
      ? dispute.CandidateBet2
      : dispute.CandidateBet1;

    uint256 ratio = (bet.amount * 1e18) / winningCandidateBet;
    uint256 individualPrize = ((winningCandidateBet + losingCandidateBet) * ratio) / 1e18;

    bet.collected = true;
    bet.collectedAmount = individualPrize;

    payable(msg.sender).transfer(individualPrize);
  }
}
