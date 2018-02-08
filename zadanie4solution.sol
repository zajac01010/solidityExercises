pragma solidity ^0.4.4;

contract BettingContractV4 {

  uint public  loserCount;
  uint public  winnerCount;

  uint public lastWinnerAt;
  
  // to zostaje
  address winner;

  // deklaracja struktury
  struct Winner {
    address winnerAddress;
    string  name;
    uint    guess;
    uint    guessedAt;
  }
  // dodanie mappingu
  mapping(address=>Winner) winnersMapping;

  uint8[3]  numArray;

  function BettingContractV4(uint8 num0, uint8 num1, uint8 num2) {
    // constructor
    numArray[0] = num0;
    numArray[1] = num1;
    numArray[2] = num2;
  }

  
  function guess(uint8 num, string name) returns (bool){

    // jesli num > 10 to revert
    if(num > 10) {
      revert();
    }

    for (uint8 i = 0 ; i < numArray.length ; i++){
      if (numArray[i] == num) {
        // Increase winner count
        winnerCount++;

        
        winnersMapping[msg.sender].winnerAddress = msg.sender;
        winnersMapping[msg.sender].name = name;
        winnersMapping[msg.sender].guess = num;
        winnersMapping[msg.sender].guessedAt = now;

        lastWinnerAt = winnersMapping[msg.sender].guessedAt;
        winner = msg.sender;

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

  // jesli address 0x0 to bez wygranego, winner przechowuje adres
  function getLastWinnerInfo() returns (address winnerAddress,
                                         string  name, 
                                         uint guess,
                                         uint    guessedAt) {
    winnerAddress = winnersMapping[winner].winnerAddress;
    name = winnersMapping[winner].name;
    guess = winnersMapping[winner].guess;
    guessedAt = winnersMapping[winner].guessedAt;
  }

    //sprawdz czy winnerAddress jest w mapie
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