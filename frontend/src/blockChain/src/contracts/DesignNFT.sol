// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import './ERC721Enumerable.sol';
import '../structs/design.sol';

contract DesignNFT is ERC721Enumerable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  // clothing proporties
  mapping(uint => Design) private infoDesignByToken;
  mapping(address => Design[]) private infoDesigsnByAddress;
  /*
  when multiple owners exist, the owner and all partners need to agree on transfering the nft.
  the key is the nft id what the process is about.
  the value is a map. the key specifies the address which is a form of partnership and the value is a boolean which is the agreement.
  */
  mapping(uint256 => mapping(address => bool)) private transferNftAgreement;
  mapping(uint256 => mapping(address => bool)) private ownersExist;

  constructor() ERC721Enumerable("Design", "AMFI") {}

  function makeNFT(address owner, string calldata name, address[] calldata lDesigners, string calldata tokenURI)
  public
  returns (uint256)
  {
    _tokenIds.increment();

    uint256 newItemId = _tokenIds.current();
    _mintSafeMain(owner, newItemId,tokenURI);
    //adding partners
    address[] memory lDesignersincOwner = new address[](lDesigners.length+1);
    lDesignersincOwner[0] = owner;
    for(uint i =1; i<lDesigners.length+1;i++){
      lDesignersincOwner[i] = lDesigners[i-1];
    }
    Design memory design = Design(name,lDesigners,tokenURI,newItemId);
    infoDesignByToken[newItemId] = design;
    // register owners to the token id
    for (uint i = 0; i < lDesigners.length; i++) {
      ownersExist[newItemId][lDesigners[i]] = true;
    }
    infoDesigsnByAddress[owner].push(design);
    return newItemId;
  }
  //Get all Nfts of the user
  function getOwnedNFTs(address owner) public view returns (string[] memory){
    uint numberOwnedNfts= infoDesigsnByAddress[owner].length;
    string[] memory nfts = new string[](numberOwnedNfts);
    for (uint256 i = 0; i < numberOwnedNfts; i++) {
      nfts[i] = infoDesigsnByAddress[owner][i].URI;
    }
    return nfts;
  }

  function agreeTransect(address partner, uint256 tokenId) public {

    require(ownersExist[tokenId][partner] == true, string(abi.encodePacked("Error: address", partner, "is not a part of ownership for this token id:", tokenId)));
    transferNftAgreement[tokenId][partner] = true;
  }
}
