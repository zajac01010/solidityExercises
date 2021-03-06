pragma solidity ^0.4.4;


contract AbstractContract1 {

  uint public constant MAX_BET=5 ether;
  uint public constant MIN_BET=1 ether;

  function guess(uint8 num, string name) public payable returns (bool);

  function totalGuesses() public returns (uint);
  
  function daysSinceLastWinning() public  returns (uint);

  function hoursSinceLastWinning() public returns (uint);

  function  minutesSinceLastWinning() public returns (uint);

  function getLastWinnerInfo() public returns (address winnerAddress,
                                         string  name,
                                         uint    guess,
                                         uint    guessedAt,
                                         uint    ethersReceived);
                                         
  function checkWinning(address winnerAddress) public returns (address retWinnerAddress, string name, uint guessVal, uint guessedAt);
}