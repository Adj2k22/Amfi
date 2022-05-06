
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import './ERC721Enumerable.sol';

contract DesignNFT is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // clothing proporties
    /*
    history of owners of token's the last owner is the current owner
    uint is the token id and unit256 is the owner
    */
    //mapping(uint256=>address[]) ownersHistory;
    /*
     ownership of the nft.
     address is the head owner who does the first transaction. in Addition to that, the head address may have some partners for that speciefic nft.
     so, key is the head owner, and value is a map. the value map issus the partnership of the speciefic nft.
     this structure is used because an address may have multiple nfts and for every nfts it is not necessary to have the same partners. 
    */
    mapping(address=>mapping(uint256=>address[])) private partners;
    /*
    when multiple owners exist, the owner and all partners need to agree on transfering the nft. 
    the key is the nft id what the process is about.
    the value is a map. the key specifies the address which is a form of partnership and the value is a boolean which is the agreement.
    */
    mapping(uint256=>mapping(address=>bool)) private transferNftAgreement;
    mapping(uint256=>mapping(address=>bool)) private ownersExist;

    constructor() ERC721Enumerable("AndrehNFT", "AFT") {}
    
    function makeNFT(address owner,string memory tokenURI, address[] memory lPartners)
    public
    returns (uint256)
    {
      _tokenIds.increment();

      uint256 newItemId = _tokenIds.current();
      _mint(owner, newItemId);
      _setTokenURI(newItemId, tokenURI);
      //adding partners
       partners[owner][newItemId]=lPartners;
       // register owners to the token id
       for(uint i = 0; i<lPartners.length; i++){
         ownersExist[newItemId][lPartners[i]] = true;
       }
       ownersExist[newItemId][owner] = true;
      return newItemId;
    }
        //Get all Nfts of the user 
        function getOwnedNFTs(address owner) public view returns(string[] memory){
        uint256[] memory nftsIds = _ownedTokensIds(owner);
        string[] memory nfts = new string[]( nftsIds.length);
        for(uint256 i = 0; i< nftsIds.length; i++){
            nfts[i] = tokenURI(nftsIds[i]);
        }
        return nfts;
    }
    function agreeTransect(address partner, uint256 tokenId)public {
      
      require(ownersExist[tokenId][partner] == true,  string(abi.encodePacked("Error: address",partner, "is not a part of ownership for this token id:",tokenId)));
      transferNftAgreement[tokenId][partner] = true;
    }
}
