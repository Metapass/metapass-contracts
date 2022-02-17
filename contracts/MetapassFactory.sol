// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Metapass.sol";
import "./MetaStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MetapassFactory is Ownable {
    MetaStorage storageProxy;

    uint256 cutNumerator = 0;
    uint256 cutDenominator = 100;

    event childEvent(address child);

    constructor(address _storageProxy) {
        storageProxy = MetaStorage(_storageProxy);
    }

    mapping(address => Metapass[]) public addressToEventMap;

    function createEvent(
        string memory title,
        uint256 fee,
        uint256 seats,
        string memory image,
        address eventHostAddress,
        string memory description,
        string memory link,
        string memory date,
        string memory category
    ) external {
        Metapass child = new Metapass(
            cutNumerator,
            cutDenominator,
            eventHostAddress,
            fee,
            address(storageProxy)
        );
        emit childEvent(address(child));
        addressToEventMap[msg.sender].push(child);
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
            category
        );
    }

    function updateRewards(uint256 num, uint256 den) public onlyOwner {
        cutNumerator = num;
        cutDenominator = den;
    }

    function getEventChildren() public view returns (Metapass[] memory) {
        return addressToEventMap[msg.sender];
    }

    function getRewards() public payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
