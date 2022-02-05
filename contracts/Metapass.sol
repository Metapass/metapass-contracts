// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./MetaStorage.sol";

contract Metapass is ERC721URIStorage, Ownable {
        
    using Counters for Counters.Counter;
    uint256 public cutNumerator = 0;
    uint256 public cutDenominator = 100;
    Counters.Counter private _tokenIdCounter;
        
    address public eventHost;
    uint256 cost;
    MetaStorage storageProxy;

    constructor(uint256 _cutNum, uint256 _cutDen, address _owner, uint256 _cost, address _storageProxy) ERC721("MetapassTickets", "METAPASS") {
        cutNumerator = _cutNum;
        cutDenominator = _cutDen;
        cost = _cost;
        eventHost = _owner;
        storageProxy = MetaStorage(_storageProxy);
    }

    function getTix (string memory tokenMetadata) payable public {
        _safeMint(msg.sender, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), tokenMetadata);
        _tokenIdCounter.increment();
        uint256 cut = msg.value * cutNumerator / cutDenominator;
        if (cut >0 ) {
            payable(owner()).transfer(cut);
        }
        payable(eventHost).transfer(msg.value - cut);
        storageProxy.emitTicketBuy(address(this), msg.sender);
    }

    function getLastTokenId() public view returns(uint256) {
        return _tokenIdCounter.current() - 1;
    }
    
}
