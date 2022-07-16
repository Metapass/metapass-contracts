// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Metapass.sol";
import "./MetaStorage.sol";

contract MetapassFactory {
    MetaStorage storageProxy;
    address owner;
    address forwarderAuthority = 0x9399BB24DBB5C4b782C70c2969F58716Ebbd6a3b;
    uint256 cutNumerator = 0;
    uint256 cutDenominator = 100;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event childEvent(address child);

    constructor(address _storageProxy) {
        storageProxy = MetaStorage(_storageProxy);
        owner = msg.sender;
    }

    mapping(address => Metapass[]) public addressToEventMap;

    function updateForwarderAuthority(address forwarder) public onlyOwner {
        forwarderAuthority = forwarder;
    }

    function createEvent(
        string memory title,
        uint256 fee,
        uint256 seats,
        string memory image,
        address eventHostAddress,
        string memory description,
        string memory link,
        string memory date,
        string memory category,
        string memory venue,
        address customToken
    ) public {
        Metapass child = new Metapass(
            cutNumerator,
            cutDenominator,
            eventHostAddress,
            fee,
            address(storageProxy),
            forwarderAuthority,
            customToken
        );
        emit childEvent(address(child));
        addressToEventMap[msg.sender].push(child);
        {
            storageProxy.pushEventDetails(
                title,
                fee,
                seats,
                image,
                eventHostAddress,
                description,
                link,
                date,
                address(child),
                category,
                venue
            );
        }
    }

    function getEventChildren() public view returns (Metapass[] memory) {
        return addressToEventMap[msg.sender];
    }

    function updateRewards(uint256 num, uint256 den) public onlyOwner {
        cutNumerator = num;
        cutDenominator = den;
    }

    function updateLink(address _event, string calldata _link) public {
        Metapass MetapassEvent = Metapass(_event);
        require(
            address(MetapassEvent.owner()) == msg.sender,
            "Not the Event Host"
        );
        storageProxy.emitLinkUpdate(_event, _link);
    }
}
