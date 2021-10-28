
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Polytix is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    bool private isMinting = false;
    mapping(address => uint256) owners;
    
    constructor() ERC721("NFTix", "TIX") {}

    function getTix (address eventOwner, string memory tokenMetadata) payable public {
        require(isMinting == true, "Service not running");
        _safeMint(msg.sender, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), tokenMetadata);
        _tokenIdCounter.increment();
        owners[eventOwner] = msg.value;
    }
    
    function _toggleMinting() onlyOwner public {
        isMinting = !isMinting;
    }
    
    function _claims() public view returns (uint256) {
        return owners[msg.sender];
    }
    
    function widthdraw() public {
        uint256 amount = owners[msg.sender];
        payable(msg.sender).send(amount);
        owners[msg.sender] = 0;
    }

}