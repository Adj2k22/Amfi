// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import './ERC721Enumerable.sol';
import '../structs/design.sol';

contract DesignNFT is ERC721Enumerable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  // clothing proporties
  // journey of token id. the key id the token id and value is the array indicates changes happend to the id. the last one is the most current
  mapping(uint => Design[]) private infoDesignByToken;
  /*
  when multiple owners exist, the owner and all partners need to agree on transfering the nft.
  the key is the nft id what the process is about.
  the value is a map. the key specifies the address which is a form of partnership and the value is a boolean which is the agreement.
  */
  mapping(uint256 => mapping(address => bool)) private transferNftAgreement;
  // register if the owners are registered to the token id to verify the agreement
  mapping(uint256 => mapping(address => bool)) private ownersExist;

  constructor() ERC721Enumerable("Design", "AMFI") {}

  function makeNFT(address owner, string calldata name, address[] calldata lDesigners, string calldata tokenURI)
  public
  returns (uint256)
  {
    _tokenIds.increment();

    uint256 newItemId = _tokenIds.current();
    _mintSafeMain(owner, newItemId, tokenURI);
    //adding partners
    address[] memory lDesignersincOwner = new address[](lDesigners.length + 1);
    // reserve fist index for the true buyer
    lDesignersincOwner[0] = owner;
    for (uint i = 1; i < lDesignersincOwner.length; i++) {
      /* we begin with index 1 becuase the first index is reserved for the true buyer
      and we copy all data from lDesigners to lDesignersincOwner. with doing this we include all involved buyers in one array
      */

      // prevent duplicate owner in lDesignersincOwner[]
      if (lDesigners[i - 1] != owner) {
        lDesignersincOwner[i] = lDesigners[i - 1];
      }
    }
    Design memory design = Design(name, lDesigners, tokenURI, newItemId);
    infoDesignByToken[newItemId].push(design);
    // register owners to the token id
    for (uint i = 0; i < lDesigners.length; i++) {
      ownersExist[newItemId][lDesigners[i]] = true;
    }
    return newItemId;
  }
  //Get all Nfts of the user
  function getOwnedURIs(address owner) public view returns(string[] memory){
    uint256[] memory nftsIds = _ownedTokensIds(owner);
    string[] memory nfts = new string[]( nftsIds.length);
    for(uint256 i = 0; i< nftsIds.length; i++){
      nfts[i] = tokenURI(nftsIds[i]);
    }
    return nfts;
  }

  function agreeTransect(address partner, uint256 tokenId) public {

    require(ownersExist[tokenId][partner] == true, string(abi.encodePacked("Error: address", partner, "is not a part of ownership for this token id:", tokenId)));
    transferNftAgreement[tokenId][partner] = true;
  }
  //get history
  function getHistory(uint tokenId)public view returns( Design[] memory){
    return infoDesignByToken[tokenId];
  }
  // get current
  function getCurrent(uint tokenId)public view returns( Design memory){
    uint indexOfcurrentUser = infoDesignByToken[tokenId].length -1;
    return infoDesignByToken[tokenId][indexOfcurrentUser];
  }
  //transfer token
  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public  override(IERC721) {
    super.safeTransferFrom(from, to,tokenId,'0x00000000000000000000000000000000');
  }
}
