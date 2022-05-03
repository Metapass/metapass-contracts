// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@opengsn/contracts/src/BaseRelayRecipient.sol";

import "./MetaStorage.sol";

contract Metapass is ERC721URIStorage, Ownable, BaseRelayRecipient {
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
    ) ERC721("MetapassTickets", "METAPASS") {
        cutNumerator = _cutNum;
        cutDenominator = _cutDen;
        cost = _cost;
        eventHost = _owner;
        storageProxy = MetaStorage(_storageProxy);
        transferOwnership(eventHost);
        _setTrustedForwarder(_forwarder);
    }

    string public override versionRecipient = "2.2.0";

    function _msgSender()
        internal
        view
        override(Context, BaseRelayRecipient)
        returns (address sender)
    {
        sender = BaseRelayRecipient._msgSender();
    }

    function _msgData()
        internal
        view
        override(Context, BaseRelayRecipient)
        returns (bytes memory)
    {
        return BaseRelayRecipient._msgData();
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
}
