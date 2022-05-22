//jshint ignore: start

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/Counters.sol";
import './enums/nftTypes.sol';
///////////////dont overwrite!!!!!!!!!!!!!!!!
contract IdGenerator {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  mapping(uint256 => NftType) private tokensNftType;
  mapping(uint256 => bool) private tokensExist;
  mapping(uint256 => address) private tokenContract;

  function giveMeId() public returns (uint256){
    require(isContract(msg.sender), "ERROR: Only Contracts Can get Id");

    _tokenIds.increment();

    (bool success, bytes memory returnData) =
    address(msg.sender)
    .call(abi
    .encodeWithSignature("getNftType()"));
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(msg.sender)), " is Failed!"));

    NftType nftTypeOfAddress = abi.decode(returnData, (NftType));
    tokensNftType[_tokenIds.current()] = nftTypeOfAddress;
    tokensExist[_tokenIds.current()] = true;
    tokenContract[_tokenIds.current()] = msg.sender;

    return _tokenIds.current();
  }

  function getCurrentMeId() public view returns (uint256){
    return _tokenIds.current();
  }

  function getNftType(uint256 tokenId) public view returns (uint8){
    uint8 typeResult = uint8(tokensNftType[tokenId]);
    return typeResult;
  }

  function getTokenContract(uint256 tokenId) public view returns (address){
    return tokenContract[tokenId];
  }

  function isContract(address addr) public view returns (bool) {
    uint size;
    assembly {size := extcodesize(addr)}
    return size > 0;
  }
}
