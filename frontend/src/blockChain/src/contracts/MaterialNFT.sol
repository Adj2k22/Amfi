// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import './ERC721Enumerable.sol';
import '../structs/material.sol';

contract MaterialNFT is ERC721Enumerable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  mapping(uint => Material[]) private infoMaterialByToken;
  mapping(address => Material[]) private infoMaterialByAddress;

  constructor() ERC721Enumerable("AndrehNFT", "AFT") {}


  function makeNFT(address owner, string calldata materialType, uint256 amount, string calldata tokenURI)
  public
  returns (uint256)
  {require(amount>0,"Error your material needs to have weight ");
    _tokenIds.increment();

    uint256 newItemId = _tokenIds.current();
    _mintSafeMain(owner, newItemId, tokenURI);
    Material memory material = Material(owner, materialType, amount, tokenURI, newItemId);
    infoMaterialByToken[newItemId].push(material);
    infoMaterialByAddress[owner].push(material);
    return newItemId;
  }
}
