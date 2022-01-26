// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Metapass.sol";
import "./MetaStorage.sol";


contract MetapassFactory {

    MetaStorage storageProxy;

    uint256 cutNumerator = 0;
    uint256 cutDenominator = 100;

    constructor(address _storageProxy) {
        storageProxy = MetaStorage(_storageProxy);
    }

    event childCreated(string title, uint256 fee, uint256 seats, string image, address eventHost, string description, string link, string date, address childAddress);

    mapping(address => Metapass[]) public addressToEventMap;

    function createEvent(string memory title, uint256 fee, uint256 seats, string memory image, address eventHostAddress, string memory description, string memory link, string memory date) external {
        Metapass child = new Metapass(cutNumerator, cutDenominator, eventHostAddress, fee);
        addressToEventMap[msg.sender].push(child);
        storageProxy.pushEventDetails(title, fee, seats, image, eventHostAddress, description, link, date, address(child));
        emit childCreated(title, fee, seats, image, eventHostAddress, description, link, date, address(child));
    }

    function getEventChildren() public view returns(Metapass[] memory) {
        return addressToEventMap[msg.sender];
    }
}
