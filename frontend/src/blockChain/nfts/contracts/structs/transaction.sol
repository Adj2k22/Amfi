pragma solidity ^0.8.0;
import "../enums/nftTypes.sol";
import "../enums/status.sol";
  struct Transaction {
    uint256 timeStamp;
    address from;
    address to;
    NftType nftType;
    tokenIdAction tokenIdAction;
  }

