// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Enumerable.sol';
import './structs/material.sol';
import './enums/nftTypes.sol';

contract MaterialNFT is ERC721Enumerable {

  NftType private constant nftType = NftType.MATERIAL;

  mapping(uint => Material[]) private infoMaterialByToken;
  mapping(address => Material[]) private infoMaterialByAddress;

  constructor() ERC721Enumerable("AndrehNFT", "AFT") {}

  function makeNFT(address owner, address IdGeneratorAddress, string calldata materialType, uint256 amount, string calldata tokenURI)
  public
  returns (uint256)
  {require(amount > 0, "Error your material needs to have weight ");
    // making call to id generator to get id for the token
    (bool success, bytes memory returnData) = address(IdGeneratorAddress).call(abi.encodeWithSignature("giveMeId()"));
    require(success, "Error: getting ID token failed");
    uint256 newItemId = uint256(bytes32(returnData));

    _mintSafeMain(owner, newItemId, tokenURI);
    Material memory material = Material(owner, materialType, amount, tokenURI, newItemId);
    infoMaterialByToken[newItemId].push(material);
    infoMaterialByAddress[owner].push(material);
    return newItemId;
  }

  function getNftType() public pure returns (NftType){
    return nftType;
  }
}
