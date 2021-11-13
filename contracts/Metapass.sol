// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Metapass is ERC721URIStorage, Ownable {
    
    
    using Counters for Counters.Counter;
    uint256 public cutNumerator = 10;
    uint256 public cutDenominator = 100;

    Counters.Counter private _tokenIdCounter;
    bool private isMinting = false;
    mapping(address => uint256) balances;
    
    constructor() ERC721("Metapass", "MPA") {}

  
    function updateCut(uint256 numerator, uint256 denominator) onlyOwner public {
        cutNumerator = numerator;
        cutDenominator = denominator;
    }
  

    function getTix (address eventOwner, string memory tokenMetadata) payable public {
        require(isMinting == true, "Service not running");
        _safeMint(msg.sender, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), tokenMetadata);
        _tokenIdCounter.increment();
        uint256 cut = msg.value * cutNumerator / cutDenominator; 
        balances[eventOwner] += msg.value - cut;
        balances[owner()] += cut;
    }
    
    function _toggleMinting() onlyOwner public {
        isMinting = !isMinting;
    }
    
    function _claims() public view returns (uint256) {
        return balances[msg.sender];
    }
    
    function widthdraw() public {
        uint256 amount = balances[msg.sender];
        payable(msg.sender).transfer(amount);
        balances[msg.sender] = 0;
    }

}