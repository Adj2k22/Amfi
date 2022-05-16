//jshint ignore: start

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/Counters.sol";

contract IdGenerator  {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  function giveMeId() public returns(uint256){
    _tokenIds.increment();
    return _tokenIds.current();
  }
  function getCurrentMeId() public view returns(uint256){
    return _tokenIds.current();
  }
}
