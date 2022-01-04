//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// OpenZeppelin ERC271 allows minting functionality (NFT)
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
// Counters is a built-in safe utilities library that contributes the minting functionality
import '@openzeppelin/contracts/utils/Counters.sol';

/**
 * Smart Contract that allows minting (create) new NFTs into a Marketplace.
 */
contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    // counters allows us to keep track of token ids
    Counters.Counter private _tokenIds;

    // address of marketplace for NFTs to interact
    address contractAddress;

    // constructor for NFT address setup
    constructor(address marketplaceAddress) ERC721('KryptoBirdz', 'KBIRDZ') {
        contractAddress = marketplaceAddress;
    }

    function mintToken(string memory tokenURI) public returns (uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        // minting requires 2 arguments: user account creating the NFT and token Id
        _mint(msg.sender, newItemId);
        // TokenURI: Id and URL
        _setTokenURI(newItemId, tokenURI);
        // give the marketplace the approval to transact between users
        setApprovalForAll(contractAddress, true);
        // mint token and set it for sell
        return newItemId;
    }
}