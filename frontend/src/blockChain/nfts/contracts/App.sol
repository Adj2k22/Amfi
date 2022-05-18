pragma solidity ^0.8.0;

import "./structs/transaction.sol";
import "./enums/clothingStatus.sol";
import "./enums/nftTypes.sol";

contract App {

  //transaction series mapping (tokenId => array Transaction[])

  // register all transactions in every operation
  //mappings from any nft to transaction
  // 998: register the parent of every child-> mapping
  // take care of feedback change on 721 from 998 on custom mappings

  function mintMaterial(address contract721Material, address IdGeneratorAddress) public {
    // dont forget to mint in the composable
    (bool success, bytes memory returnData) =
    address(contract721Material)
    //makeNFT(address owner,  address IdGeneratorAddress, string calldata materialType, uint256 amount, string calldata tokenURI)
    .call(abi
    .encodeWithSignature("makeNFT(address,address,string,uint256,string)",
      msg.sender, IdGeneratorAddress, "test", 50, "test.com")
    );
  }

  function mintDesign() public {}

  function addMaterialToDesign(
    address contract998,
    address contractMaterial721,
    uint256 materialTokenID,
    uint256 designTokenID) public {
    // check if already minted in 721 and composable
    // check ownership
    //if not minted in composable mint it! tip think about the custom tokenId in composable
    //everything alright? make material child of design
    //ComposableTopDown(contract998);
  }

  function getAllMaterialsOfOwner(address owner) public {}

  function getAllDesignsOfOwner(address owner) public {}

  function getAllClothingOfOwner(address owner) public {}

  function getMaterialOfOwner(address owner, uint256 tokenId) public {}

  function getDesignOfOwner(address owner, uint256 tokenId) public {}

  function getClothingOfOwner(address owner, uint256 tokenId) public {}

  function getHistoryOfToken() public {}

  function getIdGeneratorAddress() public view {}
  // history of transactions
  function getMaterialFromDesign() public {}
}
