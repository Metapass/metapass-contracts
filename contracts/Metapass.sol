// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Metapass is ERC721URIStorage, Ownable {
        
    using Counters for Counters.Counter;
    uint256 public cutNumerator = 0;
    uint256 public cutDenominator = 100;
    Counters.Counter private _tokenIdCounter;
        
    address public eventHost;
    uint256 cost;

    constructor(uint256 _cutNum, uint256 _cutDen, address _owner, uint256 _cost) ERC721("MetapassTickets", "METAPASS") {
        cutNumerator = _cutNum;
        cutDenominator = _cutNum;
        cost = _cost;
        eventHost = _owner;
    }

    function getTix (string memory tokenMetadata) payable public {
        _safeMint(msg.sender, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), tokenMetadata);
        _tokenIdCounter.increment();
        uint256 cut = msg.value * cutNumerator / cutDenominator;
        payable(eventHost).transfer(msg.value - cut);
        payable(owner()).transfer(cut);
    }

    function getLastTokenId() public view returns(uint256) {
        return _tokenIdCounter.current() - 1;
    }
    
}