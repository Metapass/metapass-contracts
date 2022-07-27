// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./utils/IERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";

import "./MetaStorage.sol";

contract Metapass is ERC721URIStorage, ERC2771Context, Ownable {
    using Counters for Counters.Counter;
    uint256 cutNumerator = 0;
    uint256 cutDenominator = 100;
    Counters.Counter private _tokenIdCounter;
    address eventHost;
    uint256 cost;
    MetaStorage storageProxy;
    IERC20Permit public customToken;
    bool public isCustomToken;
    bool isTransferrable = false;

    event Minted(uint256 tokenID);

    constructor(
        uint256 _cutNum,
        uint256 _cutDen,
        address _owner,
        uint256 _cost,
        address _storageProxy,
        address _forwarder,
        address _customToken
    ) ERC721("MetapassTickets", "METAPASS") ERC2771Context(_forwarder) {
        cutNumerator = _cutNum;
        cutDenominator = _cutDen;
        cost = _cost;
        eventHost = _owner;
        storageProxy = MetaStorage(_storageProxy);
        transferOwnership(eventHost);
        if (_customToken == address(0)) {
            isCustomToken = false;
        } else {
            isCustomToken = true;
            customToken = IERC20Permit(_customToken);
        }
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
        if (isTransferrable) {
            super._beforeTokenTransfer(from, to, tokenId);
        } else {
            require(
                from == address(0) ||
                    msg.sender == eventHost ||
                    to == address(0),
                "NonTransferrableERC721Token: non transferrable"
            );
            super._beforeTokenTransfer(from, to, tokenId);
        }
    }

    function getTix(string memory tokenMetadata) public payable {
        require(!isCustomToken, "Custom Token, Use getTixWithToken method");
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

    function getTixWithToken(
        string calldata tokenMetadata,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(isCustomToken, "Native Token, use getTix method");
        require(balanceOf(_msgSender()) == 0, "Already minted tickets");
        customToken.permit(
            _msgSender(),
            address(this),
            cost,
            deadline,
            v,
            r,
            s
        );
        _safeMint(_msgSender(), _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), tokenMetadata);
        uint256 cut = (cost * cutNumerator) / (cutDenominator);
        if (cut > 0) {
            bool sent = customToken.transfer(address(storageProxy), cut);
            require(sent);
        }
        customToken.transfer(address(eventHost), cost - cut);
        storageProxy.emitTicketBuy(
            address(this),
            _msgSender(),
            _tokenIdCounter.current()
        );
        _tokenIdCounter.increment();
    }

    function bulkAirdrop(address[] calldata users, string[] calldata metadata)
        external
        onlyOwner
    {
        require(users.length == metadata.length, "Metadata Length Mismatch");
        uint256 i;
        for (i = 0; i < users.length; i++) {
            _safeMint(users[i], _tokenIdCounter.current());
            _setTokenURI(_tokenIdCounter.current(), metadata[i]);
            storageProxy.emitTicketBuy(
                address(this),
                users[i],
                _tokenIdCounter.current()
            );
            _tokenIdCounter.increment();
        }
    }

    function toggleTransfers() external onlyOwner {
        isTransferrable = !isTransferrable;
    }
}
