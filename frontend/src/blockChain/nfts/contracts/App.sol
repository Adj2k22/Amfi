pragma solidity ^0.8.0;

import "./structs/transaction.sol";
import "./enums/clothingStatus.sol";
import "./enums/nftTypes.sol";

contract App {
  // register all transactions
  //mappings from any nft to transaction
  // 998: register the parent of every child-> mapping
  // take care of feedback change on 721 from 998 on custom mappings

  function mintMaterial(address contract721Material, address IdGeneratorAddress) public {
    //check in the composable if we can get id from GiveMeID()
    // dont forget to mint in the composable
    (bool success, bytes memory returnData) =
    address(contract721Material)
    //makeNFT(address owner,  address IdGeneratorAddress, string calldata materialType, uint256 amount, string calldata tokenURI)
    .call(abi
    .encodeWithSignature("makeNFT(address,address,string,uint256,string)",
      msg.sender,IdGeneratorAddress,"test",50,"test.com")
    );
  }

  function mintDesign() public {}

  function addMaterialToDesign(address contract998, address contractMaterial721) public {
    //ComposableTopDown(contract998);

  }

  function getIdGeneratorAddress() public view {}
  // history of transactions
  function getMaterialFromDesign() public {}
}
