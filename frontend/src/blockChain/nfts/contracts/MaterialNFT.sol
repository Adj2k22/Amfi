// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Enumerable.sol';
import './structs/material.sol';
import './structs/transaction.sol';
import './enums/nftTypes.sol';
import './enums/status.sol';
contract MaterialNFT is ERC721Enumerable {

  // this nft contract type
  NftType private constant nftType = NftType.MATERIAL;

  /* register the changes of every material nft tokenId.
  for example the amount subtraction after every tranaction
  */
  mapping(uint => Material[]) private infoMaterialByToken;

  mapping(uint256 => Transaction[])internal tokenIdTransactions;

  constructor() ERC721Enumerable("AndrehNFT", "AFT") {}

  function makeNFT(address owner,  address IdGeneratorAddress, string calldata materialType, uint256 amount, string calldata tokenURI)
  public
  returns (uint256)
  {require(amount>0,"Error your material needs to have weight ");
    // making call to id generator to get id for the token
    (bool success, bytes memory returnData) = address(IdGeneratorAddress).call(abi.encodeWithSignature("giveMeId()"));
    // call should be succeed to mint
    require(success, "Error: getting ID token failed");
    uint256 newItemId = uint256(bytes32(returnData));
    // mint the token
    _mintSafeMain(owner, newItemId, tokenURI);
    // make material of the given params
    Material memory material = Material( materialType, amount);
    // push the material into the array in the mapping value of the tokenId
    infoMaterialByToken[newItemId].push(material);

    tokenIdTransactions[newItemId].push(Transaction(block.timestamp, tx.origin, owner, nftType, tokenIdAction.Created));
    return newItemId;
  }
  function getNftType()public pure returns(NftType){
    return nftType;
  }
  function extractMaterialAmountAndTokenId(bytes memory data)public pure returns(bytes memory,  bytes memory){

    require(data.length%2==0);

    uint datalen = data.length;
    uint stopCondition = data.length/2;

    bytes memory tokenIdArray = new bytes(data.length/2);
    bytes memory materialAmountArray = new bytes(data.length/2);
    uint count = 0;
    uint countdown = data.length/2;
    while(datalen != stopCondition){
      tokenIdArray[count] = data[count];
      count++;
      materialAmountArray[countdown-1] = data[datalen-1];
      datalen--;
      countdown--;
    }
    return(tokenIdArray,materialAmountArray);
  }
  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public  override(IERC721,ERC721) {
    
    // to transfer the tokenId should be exist. we check that here by checking if that specifiec material has an object Material Stored in the Array in the mapping infoMaterialByToken
    require(infoMaterialByToken[tokenId].length>0);
    // when this function get called from composable just ownership will change nothing no new inputs are recieved.
    if (isContract(msg.sender)){
      // transfer
       super.safeTransferFrom(from, to,tokenId,_data);
    }else{
    // get the index of the most current Material instantie (the last element in the array)
    uint infoMaterialByTokenindex = infoMaterialByToken[tokenId].length -1;
    // break the data into tokenId and amount of the material should be spend
    (bytes memory tokenIdArray,bytes memory materialAmountArray) = extractMaterialAmountAndTokenId(_data);
    // convert bytes material amount into uint
    uint256 materialAmountToSub = bytesToUint(materialAmountArray);
    // substract the amount should be spend from the most current one
    uint newNftAmount = (infoMaterialByToken[tokenId][infoMaterialByTokenindex].amount - materialAmountToSub);
    // the new amount should be higher or equal to zero
    require(newNftAmount >= 0);
    // save the new material instantion by pushing it into the arraty 
    infoMaterialByToken[tokenId].push(Material(infoMaterialByToken[tokenId][0].materialType , newNftAmount));
    // transfer
     super.safeTransferFrom(from, to,tokenId,tokenIdArray);
     }
     // save the transaction
    tokenIdTransactions[tokenId].push(Transaction(block.timestamp, tx.origin, to, nftType, tokenIdAction.Moved));
  }

  function isContract(address addr) public view returns (bool) {
    uint size;
    assembly {size := extcodesize(addr)}
    return size > 0;
  }

  function getTransactionOfTokenId(uint256 tokenId) external view returns(Transaction[] memory) {
    return tokenIdTransactions[tokenId];
  }

    function getMaterialHistoryOfTokenId(uint256 tokenId) external view returns(Material[] memory) {
    return infoMaterialByToken[tokenId];
  }

  function bytesToUint(bytes memory b) public view returns (uint256){
    uint256 number;

    for(uint i=0;i<b.length;i++){
      number = number + uint8(b[i])*(2**(8*(b.length-(i+1))));
    }
    return number;
  }

}
