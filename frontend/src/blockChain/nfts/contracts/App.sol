pragma solidity ^0.8.0;

import "./structs/transaction.sol";
import "./enums/clothingStatus.sol";
import "./enums/nftTypes.sol";

contract App {


  /*//**//*//*transaction series mapping (tokenId => array Transaction[])
 // mapping(uint256=>Transaction)
  // register all transactions in every operation
  //mappings from any nft to transaction
  // 998: register the parent of every child-> mapping
  // take care of feedback change on 721 from 998 on custom mappings

  function mintMaterial(address contract721Material, address IdGeneratorAddress) public {
    // dont forget to mint in the composable
    (bool success, bytes memory returnData) =
    address(contract721Material)
    //makeNFT(address owner,  address IdGeneratorAddress, string calldata materialType, uint256 amount, string calldata tokenURI)
    .call(
      abi
      .encodeWithSignature("makeNFT(address,address,string,uint256,string)",
      msg.sender, IdGeneratorAddress, "test", 50, "test.com")
    );
  }

  function mintDesign(address contract721Design, address IdGeneratorAddress, address[] memory partners) public {
    (bool success, bytes memory returnData) =
    address(contract721Design)
    //makeNFT(address owner,  address IdGeneratorAddress, string calldata materialType, uint256 amount, string calldata tokenURI)
    .call(abi
    .encodeWithSignature("makeNFT(address,address,string,uint256,address[],string)",
      msg.sender, IdGeneratorAddress, "test", partners, "test.com"));
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contract721Design)), " is Failed!"));
    // register transaction
    // return uint256(bytes32(returnData));
  }

  function addMaterialToDesign(
    address contract998,
    address contractMaterial721,
    address contractDesign721,
    uint256 materialTokenID,
    uint256 designTokenID) public {

    //nft material
    // check if already minted in 721 and composable
    (bool success, bytes memory returnData) =
    address(contractMaterial721)
    .call(abi
    .encodeWithSignature("ownerOf(address)", materialTokenID));
    // check if call succeed
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contractMaterial721)), " is Failed!"));
    // require tokenId exists and ownership
    address materialTokenOwner = address(uint160(uint256(bytes32(returnData))));

    require(materialTokenOwner != address(0), string.concat("ERROR: TokenId ", string(abi.encodePacked(materialTokenID)), " does not exist!"));

    // nft Design
    (success, returnData) =
    address(contractDesign721)
    .call(abi
    .encodeWithSignature("ownerOf(address)", designTokenID));
    // check if call succeed
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contractDesign721)), " is Failed!"));
    // require tokenId exists and ownership
    address designTokenOwner = address(uint160(uint256(bytes32(returnData))));
    require(designTokenOwner != address(0), string.concat("ERROR: TokenId ", string(abi.encodePacked(designTokenID)), " does not exist!"));

    // composable
    // check material exist
    (success, returnData) =
    address(contract998)
    .call(abi
    .encodeWithSignature("childExists(address,uint256)", contractMaterial721, materialTokenID));
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contract998)), " is Failed!"));

    bool materialExistInComp = uint256(bytes32(returnData)) == 1 ? true : false;

    (success, returnData) =
    address(contract998)
    .call(abi
    .encodeWithSignature("childExists(address,uint256)", contractDesign721, designTokenID));
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contract998)), " is Failed!"));

    bool designExistInComp = uint256(bytes32(returnData)) == 1 ? true : false;

    if (!materialExistInComp) {
      (success, returnData) =
      address(contract998)
      .call(abi
      .encodeWithSignature(" mint(address,uint256)", msg.sender, materialTokenID));
      require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contract998)), " is Failed!"));
    }
    if (!designExistInComp) {
      (success, returnData) =
      address(contract998)
      .call(abi
      .encodeWithSignature("mint(address,uint256)", msg.sender, designTokenID));
      require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contract998)), " is Failed!"));
    }
    //safetransfer nfts
    (success, returnData) =
    address(contractDesign721)
    .call(abi
    .encodeWithSignature("safeTransferFrom(address,address,uint256,bytes)",
    msg.sender,contract998,designTokenID, bytes32(designTokenID)));
    // check if call succeed
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contractDesign721)), " is Failed!"));

    (success, returnData) =
    address(contractMaterial721)
    .call(abi
    .encodeWithSignature("safeTransferFrom(address,address,uint256,bytes)",
      msg.sender,contract998,materialTokenID, bytes32(materialTokenID)));
    // check if call succeed
    require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contractDesign721)), " is Failed!"));

// add child
    (success, returnData) =
    address(contract998)
    .call(abi
    .encodeWithSignature("safeTransferChild(uint256,address,address,uint256,bytes)",
    materialTokenID,contract998,contractMaterial721,materialTokenID,bytes32(designTokenID)));

  require(success, string.concat("ERROR: Call to contract:", string(abi.encodePacked(contract998)), " is Failed!"));

    // check ownership
    //if not minted in composable mint it! tip think about the custom tokenId in composable
    //everything alright? make material child of design
    //ComposableTopDown(contract998);
  }

  function getAllMaterialsOfOwner(address owner) public {}

  function getAllDesignsOfOwner(address owner) public {}

  function getAllClothingOfOwner(address owner) public {}

  function getMaterialOfClothing(address owner) public {}

  function getMaterialOfOwner(address owner, uint256 tokenId) public {}

  function getDesignOfOwner(address owner, uint256 tokenId) public {}

  function getClothingOfOwner(address owner, uint256 tokenId) public {}

  function getHistoryOfToken() public {}

  function getIdGeneratorAddress() public view {}
  // history of transactions
  function getMaterialFromDesign() public {}*/
}
