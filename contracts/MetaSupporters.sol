// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MetaSupporters is ERC721URIStorage, Ownable  {

    constructor() ERC721("Metapass Early Supporters", "MES") {}

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    function mintNFT(address _address, string memory _tokenData) onlyOwner public {
        _safeMint(_address, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), _tokenData);
        _tokenIdCounter.increment();
    }
    function getLastId() public view returns(uint256) {
        return _tokenIdCounter.current() - 1;
    }
}