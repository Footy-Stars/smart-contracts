// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract ManagerNft is ERC1155 {
    constructor()
        ERC1155(
            "ipfs://bafybeie5sl2xhjulzojmcs5gl3eyc5ez4ldfmwhu42casm77qo6p7ln7oa"
        )
    {}

    function setURI(string memory newuri) public {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        _mintBatch(to, ids, amounts, data);
    }
}