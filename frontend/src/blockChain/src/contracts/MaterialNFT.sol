// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import './ERC721Enumerable.sol';

contract DesignNFT is ERC721Enumerable {
constructor() ERC721Enumerable("AndrehNFT", "AFT") {}
}