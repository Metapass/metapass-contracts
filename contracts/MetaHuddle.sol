// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract MetaHuddle is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    constructor(address _linkToken) {
        linkContract = LinkTokenInterface(_linkToken);
        setChainlinkToken(_linkToken);
        oracle = 0x1D857F5EeCF0A47151f639251AA3Bf489f7304Af;
        jobId = "1af51f84b26b46e29d5c06b699b6fdda";
        chainlinkFee = 0;
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
    bytes32 public roomId;
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
        request.add("path", "roomId");
        return sendChainlinkRequestTo(oracle, request, chainlinkFee);
    }

    function showLink(address child) public returns (string memory) {
        string memory link = bytes32ToString(getHuddleLink(child));
        return link;
    }

    function makeString(string memory child)
        public
        view
        returns (string memory)
    {
        return string(abi.encodePacked(endpoint, "/", child));
    }

    function fulfill(bytes32 _requestId, bytes32 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {
        roomId = _volume;
    }

    function returnLink() public view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "https://metapass.huddle01.com/room?roomId=",
                    bytes32ToString(roomId)
                )
            );
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

    function bytes32ToString(bytes32 _bytes32)
        public
        pure
        returns (string memory)
    {
        uint8 i = 0;
        while (i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }
}
