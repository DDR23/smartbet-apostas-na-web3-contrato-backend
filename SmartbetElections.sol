// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartbetElections {
  address public owner;
  uint256 private constant FEE_PERCENTAGE = 1000;
  uint256 public constant CLAIM_PERIOD = 30 days;

  struct Dispute {
    uint256 id;
    string disputeName;
    string disputeWallpaper;
    string disputeCandidate1;
    string disputeCandidateImage1;
    uint256 disputeCandidateBet1;
    string disputeCandidate2;
    string disputeCandidateImage2;
    uint256 disputeCandidateBet2;
    uint256 disputeTotalBet;
    uint8 disputeWinner;
    bool disputeStatus;
    uint256 disputeCollectedFees;
    uint256 netPrize;
    uint256 finishTime;
    uint256 unclaimedPrize;
  }

  mapping(uint256 => Dispute) public disputes;
  uint256[] private disputeIds;
  uint256 private currentDisputeId;

  mapping(address => mapping(uint256 => bool)) private hasBet;

  struct Bet {
    uint256 disputeId;
    uint8 candidateChoice;
    uint256 amount;
    bool collected;
  }

  mapping(address => Bet[]) private userBets;

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  constructor() {
    owner = msg.sender;
  }

  // CRIA UMA DISPUTA
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
      id: currentDisputeId,
      disputeName: _disputeName,
      disputeWallpaper: _disputeWallpaper,
      disputeCandidate1: _disputeCandidate1,
      disputeCandidateImage1: _disputeCandidateImage1,
      disputeCandidateBet1: 0,
      disputeCandidate2: _disputeCandidate2,
      disputeCandidateImage2: _disputeCandidateImage2,
      disputeCandidateBet2: 0,
      disputeTotalBet: 0,
      disputeWinner: 0,
      disputeStatus: true,
      disputeCollectedFees: 0,
      netPrize: 0,
      finishTime: 0,
      unclaimedPrize: 0
    });
    disputeIds.push(currentDisputeId);
  }

  // RETORNA UM ARRAY COM O ID DE TODAS AS DISPUTAS
  function getAllDisputeIds() public view returns (uint256[] memory) {
    return disputeIds;
  }

  // FINALIZA UMA DISPUTA
  function finishDispute(uint256 _disputeId, uint8 _winner) public onlyOwner {
    Dispute storage dispute = disputes[_disputeId];
    dispute.disputeWinner = _winner;
    dispute.disputeStatus = false;
    dispute.finishTime = block.timestamp;
    dispute.unclaimedPrize = dispute.netPrize;
    
    uint256 fee = (dispute.disputeTotalBet * FEE_PERCENTAGE) / 10000;
    dispute.netPrize = dispute.disputeTotalBet - fee;
    dispute.disputeCollectedFees = fee;
    
    if (fee > 0) {
      payable(owner).transfer(fee);
    }
  }

  // REALIZA UMA APOSTA
  function bet(uint256 _disputeId, uint8 _candidateChoice) public payable {
    require(msg.value > 0, "Bet amount must be greater than zero");
    require(!hasBet[msg.sender][_disputeId], "You already bet on this dispute");
    Dispute storage dispute = disputes[_disputeId];
    require(dispute.disputeStatus, "This dispute is already closed");
    if (_candidateChoice == 1) {
      dispute.disputeCandidateBet1 += msg.value;
    } else {
      dispute.disputeCandidateBet2 += msg.value;
    }
    dispute.disputeTotalBet += msg.value;
    hasBet[msg.sender][_disputeId] = true;
    userBets[msg.sender].push(
      Bet({
        disputeId: _disputeId,
        candidateChoice: _candidateChoice,
        amount: msg.value,
        collected: false
      })
    );
  }

  // RETORNA TODAS AS APOSTAS DE UMA CARTEIRA
  function getUserBets(address _user) public view returns (Bet[] memory) {
    return userBets[_user];
  }

  // RETORNA TODAS AS APOSTAS DE UMA DISPUTA
  function getDisputeBets(uint256 _disputeId) public view returns (Bet[] memory) {
    Dispute storage dispute = disputes[_disputeId];
    Bet[] memory bets = new Bet[](2);
    uint256 betIndex = 0;
    if (dispute.disputeCandidateBet1 > 0) {
      bets[betIndex++] = Bet({
        disputeId: _disputeId,
        candidateChoice: 1,
        amount: dispute.disputeCandidateBet1,
        collected: false
      });
    }
    if (dispute.disputeCandidateBet2 > 0) {
      bets[betIndex++] = Bet({
        disputeId: _disputeId,
        candidateChoice: 2,
        amount: dispute.disputeCandidateBet2,
        collected: false
      });
    }
    return bets;
  }

  // REALIZA O CLAIM DE UMA APOSTA GANHA
  function claim(uint256 _disputeId) public {
    Dispute storage dispute = disputes[_disputeId];
    require(block.timestamp <= dispute.finishTime + CLAIM_PERIOD, "Claim period has expired");
    require(!dispute.disputeStatus, "This dispute is not yet closed");
    require(hasBet[msg.sender][_disputeId], "You have not bet on this dispute");
    Bet[] storage userBetList = userBets[msg.sender];
    uint256 betIndex;
    uint256 betAmount;
    uint8 chosenCandidate;
    for (uint256 i = 0; i < userBetList.length; i++) {
      if (userBetList[i].disputeId == _disputeId) {
        require(!userBetList[i].collected, "You have already claimed your prize");
        betIndex = i;
        betAmount = userBetList[i].amount;
        chosenCandidate = userBetList[i].candidateChoice;
        break;
      }
    }
    require(chosenCandidate == dispute.disputeWinner, "You did not win this dispute");
    uint256 totalWinningBets = chosenCandidate == 1 ? dispute.disputeCandidateBet1 : dispute.disputeCandidateBet2;
    uint256 winnings = (betAmount * dispute.netPrize) / totalWinningBets;
    dispute.unclaimedPrize -= winnings;
    userBetList[betIndex].collected = true;
    payable(msg.sender).transfer(winnings);
  }

  // FUNÇÃO PARA RETIRAR PRÊMIOS NÃO RECLAMADOS
  function withdrawUnclaimedPrizes(uint256 _disputeId) public onlyOwner {
    Dispute storage dispute = disputes[_disputeId];
    require(block.timestamp > dispute.finishTime + CLAIM_PERIOD, "Claim period has not yet ended");
    require(dispute.unclaimedPrize > 0, "No unclaimed prizes");
    
    uint256 amount = dispute.unclaimedPrize;
    dispute.unclaimedPrize = 0;
    payable(owner).transfer(amount);
  }
}
