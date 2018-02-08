pragma solidity ^0.4.4;

import "./abstractContract3.sol";


contract BettingContractV7 is AbstractContract3 {

  // storage variable do ownera contractu
  address  owner;
  // modifier
  modifier ownerOnly {require(msg.sender == owner); _;}

  uint public  loserCount;
  uint public  winnerCount;

  uint public   lastWinnerAt;
  
  struct Winner {
    string  name;
    address winnerAddress;
    
    uint    guess;
    uint    guessedAt;
    
    uint    ethersReceived;
  }

  address  winner;

  
 
  mapping(address=>Winner) winnersMapping;

  uint8[3]  numArray;

  function MultiNumberBettingV7(uint8 num0, uint8 num1, uint8 num2) payable{
    // ctor
    numArray[0] = num0;
    numArray[1] = num1;
    numArray[2] = num2;

    owner = msg.sender;
  }

 
  function guess(uint8 num, string name) public payable returns (bool){

    
    require(this.balance > 3*MAX_BET);

    if (num > 10) {
      revert();
    }

    if (msg.value > MAX_BET || msg.value < MIN_BET) {
      revert();
    }


    for (uint8 i = 0 ; i < numArray.length ; i++){
      if (numArray[i] == num) {
        // Increase the winner count
        winnerCount++;

        winnersMapping[msg.sender].winnerAddress = msg.sender;
        winnersMapping[msg.sender].name = name;
        winnersMapping[msg.sender].guess = num;
        winnersMapping[msg.sender].guessedAt = now;
        
        winnersMapping[msg.sender].ethersReceived = msg.value;

        lastWinnerAt = winnersMapping[msg.sender].guessedAt;
        winner = msg.sender;

        
        //jesli winner, to update w strukturze
        // TODO: zrobic to za pomoca withdrawal pattern
        uint sendBack = 2*msg.value;
        msg.sender.transfer(sendBack);

        // update dla nowych eventow
        WinningBet(winner, name, msg.value);

        return true;
      }
    }
    loserCount++;
    // update dla nowych eventow
    LosingBet(winner, name, msg.value);
        
    return false;
  }

  function totalGuesses() returns (uint){
    return (loserCount+winnerCount);
  }

  function daysSinceLastWinning()  returns (uint){
    return (now - lastWinnerAt*1 days);
  }

  function hoursSinceLastWinning() returns (uint){
    return (now - lastWinnerAt*1 hours);
  }

  function  minutesSinceLastWinning() returns (uint){
    return (now - lastWinnerAt*1 minutes);
  }

  function getLastWinnerInfo() returns (address winnerAddress,
                                         string  name, 
                                         uint guess,
                                         uint    guessedAt,
                                         uint    ethersReceived) {
    winnerAddress = winnersMapping[winner].winnerAddress;
    name = winnersMapping[winner].name;
    guess = winnersMapping[winner].guess;
    guessedAt = winnersMapping[winner].guessedAt;
    
    ethersReceived = winnersMapping[winner].ethersReceived;
  }

  function checkWinning(address winnerAddress) public returns (address retWinnerAddress, string name, uint guessVal, uint guessedAt) {
    Winner memory winnerLocal = winnersMapping[winnerAddress];
    if (winnerLocal.guessedAt != 0) {
        retWinnerAddress = winnerLocal.winnerAddress;
        name = winnerLocal.name;
        guessVal = winnerLocal.guess;
        guessedAt = winnerLocal.guessedAt;
    }
  }
  
  function ownerWithdraw(uint amt) ownerOnly {
    if ((this.balance - amt) > 3*MAX_BET) {
      msg.sender.transfer(amt);
    } else {
      revert();
    }
  }

   // bez payable fallback nie bedziemy w stanie przeslac etheru
  function() public payable {
    // na razie puste
  }

}