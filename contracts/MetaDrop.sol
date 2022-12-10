// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MetaDrop is ERC721 {
    uint256 public tokenID;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function drop() external {
        _drop(msg.sender);
    }

    function multiDrop(address[] calldata recepients) external {
        for (uint256 i = 0; i < recepients.length; ) {
            _drop(recepients[i]);
            unchecked {
                i++;
            }
        }
    }

    function _drop(address recepient) internal {
        _mint(recepient, tokenID);
        unchecked {
            tokenID++;
        }
    }
}
