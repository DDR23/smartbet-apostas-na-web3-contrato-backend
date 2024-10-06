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
}