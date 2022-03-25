// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Metapass.sol";
import "./MetaStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract MetapassFactory is Ownable, ChainlinkClient {
    MetaStorage storageProxy;
    using Chainlink for Chainlink.Request;

    // Chainlink Variables
    uint256 public volume;

    address private oracle;
    bytes32 private jobId;
    uint256 private chainlinkFee;
    LinkTokenInterface public linkContract;

    uint256 cutNumerator = 0;
    uint256 cutDenominator = 100;

    event childEvent(address child);

    constructor(address _storageProxy, address _linkToken) {
        linkContract = LinkTokenInterface(_linkToken);
        storageProxy = MetaStorage(_storageProxy);
        setChainlinkToken(_linkToken);
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        chainlinkFee = 0.1 * 10**18; // (Varies by network and job)
    }

    mapping(address => Metapass[]) public addressToEventMap;

    function getHuddleLink(address child) public returns (bytes32 link) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        request.add(
            "get",
            string(
                abi.encodePacked(
                    "https://metapass-huddle.herokuapp.com/api/getHuddle",
                    child
                )
            )
        );
        return sendChainlinkRequestTo(oracle, request, chainlinkFee);
    }

    function fulfill(bytes32 _requestId, uint256 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;
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
        string memory venue
    ) public {
        Metapass child = new Metapass(
            cutNumerator,
            cutDenominator,
            eventHostAddress,
            fee,
            address(storageProxy)
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

    function withdrawLink() public onlyOwner {
        linkContract.transfer(
            msg.sender,
            linkContract.balanceOf(address(this))
        );
    }

    function getEventChildren() public view returns (Metapass[] memory) {
        return addressToEventMap[msg.sender];
    }

    function updateRewards(uint256 num, uint256 den) public onlyOwner {
        cutNumerator = num;
        cutDenominator = den;
    }
}
