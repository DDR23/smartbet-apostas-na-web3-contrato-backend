// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SmartbetDisputes {
  address public owner;
  uint256 private constant FEE_PERCENTAGE = 1000;
  uint256 private constant CLAIM_PERIOD = 30 days;

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  struct Dispute {
    string disputeName;
    string disputeWallpaper;
    string disputeCandidate1;
    string disputeCandidateImage1;
    uint256 disputeCandidateBet1;
    string disputeCandidate2;
    string disputeCandidateImage2;
    uint256 disputeCandidateBet2;
    uint8 disputeWinner;
    uint256 disputeNetPrize;
    uint256 disputeFinishTime;
    uint256 disputeFee;
  }

  mapping(uint256 => Dispute) public disputes;
  uint256[] private disputeIds;
  uint256 private currentDisputeId;

  struct Bet {
    uint256 disputeId;
    uint8 candidateNumber;
    uint256 amount;
    bool collected;
  }

  mapping(address => mapping(uint256 => Bet)) public walletBets;
  mapping(address => uint256[]) private walletDisputeIds;

  constructor() {
    owner = msg.sender;
  }

  function createDispute(
    string memory _disputeName,
    string memory _disputeWallpaper,
    string memory _disputeCandidate1,
    string memory _disputeCandidateImage1,
    string memory _disputeCandidate2,
    string memory _disputeCandidateImage2
  ) public onlyOwner {
    currentDisputeId++;
    disputes[currentDisputeId] = Dispute({
      disputeName: _disputeName,
      disputeWallpaper: _disputeWallpaper,
      disputeCandidate1: _disputeCandidate1,
      disputeCandidateImage1: _disputeCandidateImage1,
      disputeCandidate2: _disputeCandidate2,
      disputeCandidateImage2: _disputeCandidateImage2,
      disputeCandidateBet1: 0,
      disputeCandidateBet2: 0,
      disputeWinner: 0,
      disputeNetPrize: 0,
      disputeFinishTime: 0,
      disputeFee: 0
    });
    disputeIds.push(currentDisputeId);
  }

  function getAllDisputeIds() public view returns (uint256[] memory) {
    return (disputeIds);
  }

  function createBet(uint256 _disputeId, uint8 _candidateNumber) public payable {
    require(msg.value > 0, "Bet value must be greater than zero");
    require(disputes[_disputeId].disputeWinner == 0, "Dispute already finished");
    require(walletBets[msg.sender][_disputeId].amount == 0, "Already bet on this dispute");

    Dispute storage dispute = disputes[_disputeId];

    uint256 fee = (msg.value * FEE_PERCENTAGE) / 10000;
    uint256 netBet = msg.value - fee;

    if (_candidateNumber == 1) {
      dispute.disputeCandidateBet1 += netBet;
    } else {
      dispute.disputeCandidateBet2 += netBet;
    }

    dispute.disputeFee += fee;
    dispute.disputeNetPrize += netBet;

    Bet memory newBet = Bet({
      disputeId: _disputeId,
      candidateNumber: _candidateNumber,
      amount: netBet,
      collected: false
    });

    walletBets[msg.sender][_disputeId] = newBet;
    walletDisputeIds[msg.sender].push(_disputeId);
  }

  function getAllWalletBets(address _wallet) public view returns (uint256[] memory) {
    return walletDisputeIds[_wallet];
  }

  function getBetDetails(address _wallet, uint256 _disputeId) public view returns (Bet memory) {
    return walletBets[_wallet][_disputeId];
  }

  //TODO - finishBet
  //TODO - Claim
}