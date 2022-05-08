pragma solidity ^0.8.0;
import './ERC721Enumerable.sol';
import './DesignNFT.sol';
import './MaterialNFT.sol';
contract ClothingNFT {
  DesignNFT private designNFT;
  MaterialNFT private materialNFT;
  //mapping
  //usage of material in design
  //which materials used in clothing

  //functions
  //prevent double spending for matirals
  // make transactions in every action (enums) minting, make clothing,spending designing
  //transform ownership and change root owners
  //history conclusions

  constructor(){}
}
