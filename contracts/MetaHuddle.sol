// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract MetaHuddle is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    constructor(address _linkToken) {
        linkContract = LinkTokenInterface(_linkToken);
        setChainlinkToken(_linkToken);
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        chainlinkFee = 0.1 * 10**18;
    }

    modifier onlyOwner() {
        require(
            msg.sender == address(0x28172273CC1E0395F3473EC6eD062B6fdFb15940)
        );
        _;
    }

    string private endpoint =
        "https://metapass-huddle.herokuapp.com/api/getHuddle";

    // Chainlink Variables
    uint256 public volume;
    address private oracle;
    bytes32 private jobId;
    uint256 private chainlinkFee;
    LinkTokenInterface public linkContract;

    function getHuddleLink(address child) public returns (bytes32 link) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        request.add("get", makeString(toAsciiString(child)));
        return sendChainlinkRequestTo(oracle, request, chainlinkFee);
    }

    function makeString(string memory child)
        public
        view
        returns (string memory)
    {
        return string(abi.encodePacked(endpoint, "/", child));
    }

    function fulfill(bytes32 _requestId, uint256 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;
    }

    function withdrawLink() public onlyOwner {
        linkContract.transfer(
            msg.sender,
            linkContract.balanceOf(address(this))
        );
    }

    function toAsciiString(address x) public pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(abi.encodePacked("0x", s));
    }

    function char(bytes1 b) public pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
