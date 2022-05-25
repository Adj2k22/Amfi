// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Enumerable.sol';
import './structs/design.sol';
import './structs/transaction.sol';
import './enums/nftTypes.sol';
import './enums/status.sol';

contract DesignNFT is ERC721Enumerable {
  NftType private constant nftType = NftType.BRAND;
  function getNftType()public view returns(NftType){
    return nftType;
  }
  // clothing proporties
  // journey of token id. the key id the token id and value is the array indicates changes happend to the id. the last one is the most current
  mapping(uint => Design) private infoDesignByToken;
  /*
  when multiple owners exist, the owner and all partners need to agree on transfering the nft.
  the key is the nft id what the process is about.
  the value is a map. the key specifies the address which is a form of partnership and the value is a boolean which is the agreement.
  */
  mapping(uint256 => mapping(address => bool)) private transferNftAgreement;
  // register if the owners are registered to the token id to verify the agreement
  mapping(uint256 => mapping(address => bool)) private ownersExist;

  mapping(uint256 => Transaction[])internal tokenIdTransactions;

  constructor() ERC721Enumerable("Design", "AMFI") {}

  function makeNFT(address owner, address IdGeneratorAddress, string calldata designType, address[] calldata lDesigners, string calldata tokenURI)
  public
  returns (uint256)
  {
    // making call to id generator to get id for the token
    (bool success, bytes memory returnData) = address(IdGeneratorAddress).call(abi.encodeWithSignature("giveMeId()"));
    require(success, "Error: getting ID token faild");
    uint256 newItemId = uint256(bytes32(returnData));

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
    infoDesignByToken[newItemId] =  Design(designType, lDesigners);
    // register owners to the token id
    for (uint i = 0; i < lDesigners.length; i++) {
      ownersExist[newItemId][lDesigners[i]] = true;
    }
    tokenIdTransactions[newItemId].push(Transaction(block.timestamp, tx.origin, owner, nftType, tokenIdAction.Created));
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

  function agreeTransect( uint256 tokenId) public {

    require(ownersExist[tokenId][msg.sender] == true, string(abi.encodePacked("Error: address", msg.sender, "is not a part of ownership for this token id:", tokenId)));
    transferNftAgreement[tokenId][msg.sender] = true;
  }

  // get Design
  function getDesign(uint tokenId)public view returns( Design memory){
    return infoDesignByToken[tokenId];
  }
  function getTransactionOfTokenId(uint256 tokenId) external view returns(Transaction[] memory) {
    return tokenIdTransactions[tokenId];
  }

}
