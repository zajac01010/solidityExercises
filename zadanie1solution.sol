pragma solidity ^0.4.4;

contract BettingContractV1 {

  //  storage variables
  uint  loserCount;
  uint  winnerCount;

  uint8[3]  numArray;

  //  3 uint8 jako param
  function BettingContractV1(uint8 num0, uint8 num1, uint8 num2) {
    // ctor
    numArray[0] = num0;
    numArray[1] = num1;
    numArray[2] = num2;
  }

  // dodanie funkcji guess
  function guess(uint8 num) returns (bool){
    for(uint8 i = 0 ; i < numArray.length ; i++){
      if(numArray[i] == num) {
        // zwieksz winner count
        winnerCount++;
        return true;
      }
    }
    loserCount++;
    return false;
  }

  // zwraca number of guesses
  function totalGuesses() returns (uint){
    return (loserCount+winnerCount);
  }

}