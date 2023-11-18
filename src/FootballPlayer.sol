// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FootballPlayer is ERC721, ERC721URIStorage {
    uint256 private _nextTokenId;

    error SupplyExceeded();
    event Minted(address indexed account, uint256 supply);
    uint256 public constant MAX_SUPPLY = 3000;

    constructor() ERC721("FootballPlayer", "FTS") {}

    function safeMint() external {
        address sender = msg.sender;
        uint256 tokenId = _nextTokenId++;
        _safeMint(sender, tokenId);
        _setTokenURI(
            tokenId,
            "https://nftstorage.link/ipfs/bafybeidexodcpjaki3zymsrdxmar3goyzyez2vopj2tgg4mcw5quxexhpy/"
        );
        emit Minted(sender, tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function checkSupply() internal view returns (bool) {
        return _nextTokenId + 1 <= MAX_SUPPLY;
    }
}
