pragma solidity ^0.4.4;

contract BettingContractV2 {

  uint  loserCount;
  uint  winnerCount;

  // storage variable
  string lastWinnerName ;

  uint8[3]  numArray;

  function BettingContractV2(uint8 num0, uint8 num1, uint8 num2) {
    // constructor
    numArray[0] = num0;
    numArray[1] = num1;
    numArray[2] = num2;
  }

  // funkcja teraz przyjmuje 2 parametry
  function guess(uint8 num, string name) returns (bool){
    for(uint8 i = 0 ; i < numArray.length ; i++){
      if(numArray[i] == num) {
        // update the winner name
        winnerCount++;
        lastWinnerName = name;
        return true;
      }
    }
    loserCount++;
    return false;
  }

  function totalGuesses() public returns (uint) {
    return (loserCount+winnerCount);
  }


  // improving getLastWinner
  function getLastWinner() returns (string) {

    bytes memory nameBytes = bytes(lastWinnerName);
    // jelsi nikt nie wygral to send "***"
    if (nameBytes.length == 0) {
      return "***";
    }

    string memory retString = new string(3);

    bytes memory toReturn = bytes(retString);

    // return the first 3 bytes of the winner name
    for (uint i = 0; (i < 3) && (i < nameBytes.length); i++) {
      toReturn[i] = nameBytes[i];
    }

    return string(toReturn);
  }
  
}