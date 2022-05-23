pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;
import "./ComposableTopDown.sol";

contract ClothingC is ComposableTopDown {
  //enums
  enum TokenIdAction {Created, Moved, Composed}
  enum NftType {CLOTHING, MATERIAL, BRAND}
  //structs
  struct Transaction {
    uint256 timeStamp;
    address from;
    address to;
    NftType nftType;
    TokenIdAction tokenIdAction;
  }

  NftType private constant nftType = NftType.CLOTHING;


  mapping(uint256 => Transaction[])internal tokenIdTransactions;
  mapping(uint256 => uint256)internal parentChildsLen;
  mapping(uint256 => uint256)internal childToParent;
  uint256[] internal  clothingTokens;


  function mint(address _to, uint256 tokenId, address IdGenerator) public returns (uint256) {
    address tokenIdContract = getContractTokenId(IdGenerator, tokenId);
    address tokenOwner = getOwnerTokenId(tokenIdContract, tokenId);
    require(tokenOwner == msg.sender);
    uint256 mintiedToken = super.mint(_to, tokenId);
    // get the most current id from the generator to valid the tokenId
    uint256 id = uint256(getCurrentIDFromGenerator(IdGenerator));
    // the id token id is not vaild if it is higher then the genarated id, becuase it is not generated yet!
    require(tokenId <= id, "Error: invalid tokenId");
    NftType tokenType = NftType(getNftTypeOfTokenId(IdGenerator, tokenId));

    if (tokenType == NftType.BRAND) {
      clothingTokens.push(tokenId);
    }
    tokenIdTransactions[tokenId].push(Transaction(now, msg.sender, address(this), tokenType, TokenIdAction.Created));


    return mintiedToken;
  }

  function safeTransferChildMain(address idGenerator, uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId, bytes _data) external{
    uint256 toParentTokenID =  uint256(bytes32(convertBytesToBytes8(_data)));
    NftType parentTokenType = NftType(getNftTypeOfTokenId(idGenerator, toParentTokenID));
    NftType childTokenType = NftType(getNftTypeOfTokenId(idGenerator, _childTokenId));
    require(childTokenType == parentTokenType && parentTokenType == NftType.BRAND, "you cant add design to design");

    parentChildsLen[toParentTokenID]++;
    childToParent[_childTokenId] = toParentTokenID;
    tokenIdTransactions[toParentTokenID].push(Transaction(now, msg.sender, address(this), parentTokenType, TokenIdAction.Composed));
    tokenIdTransactions[_childTokenId].push(Transaction(now, msg.sender, address(this), childTokenType, TokenIdAction.Composed));
    safeTransferChild(_fromTokenId,_to,_childContract,_childTokenId,_data);
  }

  function getCurrentIDFromGenerator(address idGenerator) public returns (int value) {
    address addr = address(idGenerator);
    bytes4 sig = bytes4(keccak256("getCurrentMeId()"));

    assembly {
      let o := mload(0x40) // Empty storage pointer
      mstore(o, sig)        // Push function signature to memory (function signature is 4 bytes/0x04)
    //mstore(add(ptr,0x40), someInt32Argument); // Append function argument after signature
    // From here, the call data size (input) would be functiona signature size + sum(argument size)
    //   4bytes + 0 in this case, or 4bytes + 32bytes in the above commented `mstore`

      let success := call(
      15000, // Gas limit
      addr, // To address
      0, // No ether to transfer
      o, // Input location ptr
      0x04, // Input size (0)
      o, // Store oputput over input
      0x20)            // Output size (32 bytes)

      value := mload(o)
      mstore(0x40, add(o, 0x04))
    }
  }


  function getNftTypeOfTokenId(address idGenerator, uint256 tokenId) public view returns (uint8 value){
    address addr = address(idGenerator);
    bytes4 sig = bytes4(keccak256("getNftType(uint256)"));

    assembly {
      let o := mload(0x40) // Empty storage pointer
      mstore(o, sig)
      mstore(add(o, 0x04), tokenId)       // Push function signature to memory (function signature is 4 bytes/0x04)
    //mstore(add(ptr,0x40), someInt32Argument); // Append function argument after signature
    // From here, the call data size (input) would be functiona signature size + sum(argument size)
    //   4bytes + 0 in this case, or 4bytes + 32bytes in the above commented `mstore`

      let success := call(//This is the critical change (Pop the top stack value)
      5000, //5k gas
      addr, //To addr
      0, //No value
      o, //Inputs are stored at location x
      0x44, //Inputs are 68 bytes long
      o, //Store output over input (saves space)
      0x20) //Outputs are 32 bytes long

      value := mload(o) //Assign output value to c
      mstore(0x40, add(o, 0x44)) // Set storage pointer to empty space
    }
  }

  function getContractTokenId(address idGenerator, uint256 tokenId) public view returns (address value){
    address addr = address(idGenerator);
    bytes4 sig = bytes4(keccak256("getTokenContract(uint256)"));

    assembly {
      let o := mload(0x40) // Empty storage pointer
      mstore(o, sig)
      mstore(add(o, 0x04), tokenId)       // Push function signature to memory (function signature is 4 bytes/0x04)
    //mstore(add(ptr,0x40), someInt32Argument); // Append function argument after signature
    // From here, the call data size (input) would be functiona signature size + sum(argument size)
    //   4bytes + 0 in this case, or 4bytes + 32bytes in the above commented `mstore`

      let success := call(//This is the critical change (Pop the top stack value)
      5000, //5k gas
      addr, //To addr
      0, //No value
      o, //Inputs are stored at location x
      0x44, //Inputs are 68 bytes long
      o, //Store output over input (saves space)
      0x20) //Outputs are 32 bytes long

      value := mload(o) //Assign output value to c
      mstore(0x40, add(o, 0x44)) // Set storage pointer to empty space
    }
  }

  function getOwnerTokenId(address tokenIdContract, uint256 tokenId) public view returns (address value){
    address addr = address(tokenIdContract);
    bytes4 sig = bytes4(keccak256("ownerOf(uint256)"));

    assembly {
      let o := mload(0x40) // Empty storage pointer
      mstore(o, sig)
      mstore(add(o, 0x04), tokenId)       // Push function signature to memory (function signature is 4 bytes/0x04)
    //mstore(add(ptr,0x40), someInt32Argument); // Append function argument after signature
    // From here, the call data size (input) would be functiona signature size + sum(argument size)
    //   4bytes + 0 in this case, or 4bytes + 32bytes in the above commented `mstore`

      let success := call(//This is the critical change (Pop the top stack value)
      5000, //5k gas
      addr, //To addr
      0, //No value
      o, //Inputs are stored at location x
      0x44, //Inputs are 68 bytes long
      o, //Store output over input (saves space)
      0x20) //Outputs are 32 bytes long

      value := mload(o) //Assign output value to c
      mstore(0x40, add(o, 0x44)) // Set storage pointer to empty space
    }
  }
  function convertBytesToBytes8(bytes inBytes) internal pure returns (bytes8 outBytes8) {
    if (inBytes.length == 0) {
      return 0x0;
    }

    assembly {
      outBytes8 := mload(add(inBytes, 32))
    }
  }
  // get transactions
  function getTransactionOfTokenId(uint256 tokenId) external view returns(Transaction[] calldata) {
    return tokenIdTransactions[tokenId];
  }
  // get parent of child
  function getparentTokenIdOfchild(uint256 tokenId) external view returns(uint256) {
    return childToParent[tokenId];
  }
  // get childeren of parent
  function getChildTokenIdsOfParent(uint256 tokenId, address IdGenerator) external view returns(uint256[] calldata) {
    uint256[] memory childs = new uint256[](parentChildsLen[tokenId]);
    address tokenIdContract = getContractTokenId(IdGenerator, tokenId);
    for (uint i = 0; i<childs.length;i++){
      childs[i] = childTokenByIndex(tokenId,tokenIdContract,i);
    }
    return childs;
  }
}
