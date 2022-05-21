pragma solidity ^0.4.24;

import "./ComposableTopDown.sol";

contract ClothingC is ComposableTopDown {


  NftType private constant nftType = NftType.CLOTHING;


  mapping(uint256 => Transaction[])private tokenIdTransactions;
  mapping(uint256 => uint256[])private clothingToMaterials;
  mapping(uint256 => uint256)private materialToClothing;
  uint256[] private  clothingTokens;


  uint256 public test;

  function mint(address _to, uint256 tokenId, address IdGenerator) public returns (uint256) {


    //makeNFT(address owner,  address IdGeneratorAddress, string calldata materialType, uint256 amount, string calldata tokenURI)
    uint256 id = uint256(getCurrentIDFromGenerator(IdGenerator));
    require(tokenId <= id, "Error: invalid tokenId");
    // get nft type and push to mapping!!
    return super.mint(_to, tokenId);
  }

  enum TokenIdAction {Created, Moved, Composed}
  enum NftType {CLOTHING, MATERIAL, DESIGN}
  struct Transaction {
    uint256 timeStamp;
    address from;
    address to;
    NftType nftType;
    TokenIdAction tokenIdAction;
    uint256 TokenId;
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

  function getNftTypeOfTokenId(address idGenerator, int tokenId) public view returns (uint256 value){
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

}
