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
    
    struct EventData {
        string encryptedLink;
        string title;
    }
    
    bool private isMinting = false;
    mapping(address => uint256) balances;
    mapping(address => EventData[]) detailsMap; 
    
    event Minted (
        uint256 indexed _id
    );
    
    constructor() ERC721("Metapass", "MPA") {}

  
    function updateCut(uint256 numerator, uint256 denominator) onlyOwner public {
        cutNumerator = numerator;
        cutDenominator = denominator;
    }
  

    function getTix (address eventOwner, string memory tokenMetadata, string memory _link, string memory _title) payable public returns (uint256) {
        require(isMinting == true, "Service not running");
        _safeMint(msg.sender, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), tokenMetadata);
        uint256 returnId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        uint256 cut = msg.value * cutNumerator / cutDenominator;
        EventData memory _tempEventData = EventData(
            _link,
            _title
        );
        detailsMap[msg.sender].push(_tempEventData);
        balances[eventOwner] += msg.value - cut;
        balances[owner()] += cut;
        return returnId;
    }
    
    function getEventDetails() public view returns (EventData[]  memory _EventData) {
        return detailsMap[msg.sender];
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