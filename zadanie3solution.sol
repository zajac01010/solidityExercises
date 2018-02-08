pragma solidity ^0.4.4;

contract BettingContractV3 {

  
  // publiczne gettery
  uint public  loserCount;
  uint public  winnerCount;

  uint public lastWinnerAt;
  string lastWinnerName ;

  // adres ostatniego winnera
  address winner;

  uint8[3]  numArray;

  function BettingContractV3(uint8 num0, uint8 num1, uint8 num2) {
    // constructor
    numArray[0] = num0;
    numArray[1] = num1;
    numArray[2] = num2;
  }

  
  function guess(uint8 num, string name) returns (bool) {

    
    // if function > 10 indicate an exception
    // albo mozna tez tak require(num <= 10)
    if (num > 10) {
      revert();
    }

    for (uint8 i = 0 ; i < numArray.length ; i++) {
      if (numArray[i] == num) {
        // Increase winner count
        winnerCount++;
        lastWinnerName = name;

        // update to set the time
        lastWinnerAt = now;

        // address tego ktory wygral
        winner = msg.sender;

        return true;
      }
    }
    loserCount++;
    return false;
  }

  function totalGuesses() public returns (uint) {
    return (loserCount+winnerCount);
  }


  
  function getLastWinner() returns (string) {

    bytes memory nameBytes = bytes(lastWinnerName);

    // If no winner send "***"
    if (nameBytes.length == 0) {
      return "***";
    }

    string memory retString = new string(3);

    bytes memory toReturn = bytes(retString);

    // return the first 3 bytes of the winner name
    for (uint i = 0; (i < 3) && (i < nameBytes.length) ; i++) {
      toReturn[i] = nameBytes[i];
    }

    return string(toReturn);
  }

  // funkcje pomocniczne wymagane do zadania
  function daysSinceLastWinning()  public returns (uint) {
    return (now - lastWinnerAt*1 days);
  }

  function hoursSinceLastWinning() public returns (uint) {
    return (now - lastWinnerAt*1 hours);
  }

  function  minutesSinceLastWinning() public returns (uint) {
    return (now - lastWinnerAt*1 minutes);
  }

  function timeSinceLastWinner() private constant returns(uint) {
    uint timeSince = now - lastWinnerAt * 1 seconds;

    timeSince < now ? lastWinnerAt : 0;
  }
  
}