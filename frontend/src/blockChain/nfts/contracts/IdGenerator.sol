//jshint ignore: start

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/Counters.sol";
import './enums/nftTypes.sol';
///////////////dont overwrite!!!!!!!!!!!!!!!!
contract IdGenerator {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  mapping(uint256 => NftType) tokensNftType;

  function giveMeId() public returns (uint256){
    require(isContract(msg.sender), "ERROR: Only Contracts Can get Id");
    _tokenIds.increment();

    (bool success, bytes memory returnData) =
    address(msg.sender)
    //makeNFT(address owner,  address IdGeneratorAddress, string calldata materialType, uint256 amount, string calldata tokenURI)
    .call(abi
    .encodeWithSignature("getNftType()"));
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(msg.sender)), " is Failed!"));
    NftType nftTypeOfAddress = abi.decode(returnData, (NftType));
    tokensNftType[_tokenIds.current()] = nftTypeOfAddress;
    return _tokenIds.current();
  }

  function getCurrentMeId() public returns (uint256){
    return _tokenIds.current();
  }

  function getNftType(uint256 tokenId) public returns (NftType){
    return tokensNftType[tokenId];
  }

  function isContract(address addr) public view returns (bool) {
    uint size;
    assembly {size := extcodesize(addr)}
    return size > 0;
  }
}
