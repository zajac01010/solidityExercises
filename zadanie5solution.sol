pragma solidity ^0.4.4;


import "./abstractContract1.sol";

contract BettingContractV5 is contract AbstractContract1 {
 {

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

  function BettingContractV5(uint8 num0, uint8 num1, uint8 num2) payable{
    // ctor
    numArray[0] = num0;
    numArray[1] = num1;
    numArray[2] = num2;
  }

  //zmieniamy na payable bo przyjmuje etery
  function guess(uint8 num, string name) public payable returns (bool){

    // If num > 10 revert
    if (num > 10) {
      revert();
    }

    // jesli poza zakresem, to revert
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
        // jesli przegrana, zatrzymujemy ethery
        winnersMapping[msg.sender].ethersReceived = msg.value;

        lastWinnerAt = winnersMapping[msg.sender].guessedAt;
        winner = msg.sender;

        //jesli winner, to update w strukturze
        // TODO: zrobic to za pomoca withdrawal pattern

        uint sendBack = 2*msg.value;
        msg.sender.transfer(sendBack);

        return true;
      }
    }
    loserCount++;
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
                                         //odeslanie etheru
                                         uint    ethersReceived) {
    winnerAddress = winnersMapping[winner].winnerAddress;
    name = winnersMapping[winner].name;
    guess = winnersMapping[winner].guess;
    guessedAt = winnersMapping[winner].guessedAt;
     //odeslanie etheru
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
  
}