// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";

import "./MetaStorage.sol";

contract Metapass is ERC721URIStorage, ERC2771Context, Ownable {
    using Counters for Counters.Counter;
    uint256 public cutNumerator = 0;
    uint256 public cutDenominator = 100;
    Counters.Counter private _tokenIdCounter;
    address public eventHost;
    uint256 cost;
    MetaStorage storageProxy;

    event Minted(uint256 tokenID);

    constructor(
        uint256 _cutNum,
        uint256 _cutDen,
        address _owner,
        uint256 _cost,
        address _storageProxy,
        address _forwarder
    ) ERC721("MetapassTickets", "METAPASS") ERC2771Context(_forwarder) {
        cutNumerator = _cutNum;
        cutDenominator = _cutDen;
        cost = _cost;
        eventHost = _owner;
        storageProxy = MetaStorage(_storageProxy);
        transferOwnership(eventHost);
    }

    function _msgSender()
        internal
        view
        override(Context, ERC2771Context)
        returns (address)
    {
        return ERC2771Context._msgSender();
    }

    function _msgData()
        internal
        view
        override(Context, ERC2771Context)
        returns (bytes calldata)
    {
        return ERC2771Context._msgData();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721) {
        require(
            from == address(0) || to == address(0),
            "NonTransferrableERC721Token: non transferrable"
        );
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function getTix(string memory tokenMetadata) public payable {
        require(balanceOf(_msgSender()) == 0, "Already minted tickets");
        _safeMint(_msgSender(), _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), tokenMetadata);
        emit Minted(_tokenIdCounter.current());
        uint256 cut = (msg.value * cutNumerator) / (cutDenominator);
        if (cut > 0) {
            payable(address(storageProxy)).transfer(cut);
        }
        payable(eventHost).transfer(address(this).balance);
        storageProxy.emitTicketBuy(
            address(this),
            _msgSender(),
            _tokenIdCounter.current()
        );
        _tokenIdCounter.increment();
    }

    function bulkAirdrop(address[] users, string[] metadata)
        external
        onlyOwner
    {
        require(users.length == metadata.length, "Metadata Length Mismatch");
        for (uint256 i = 0; i < users.length; i++) {
            _safeMint(address[i], _tokenIdCounter.current());
            _setTokenURI(_tokenIdCounter.current(), metadata[i]);
            storageProxy.emitTicketBuy(
                address(this),
                address[i],
                _tokenIdCounter.current()
            );
            _tokenIdCounter.increment();
        }
    }
}
