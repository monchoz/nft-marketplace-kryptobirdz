//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// OpenZeppelin ERC271 allows minting functionality (NFT)
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
// Security against transactions for multiple requests
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
// Counters is a built-in safe utilities library that contributes the minting functionality
import '@openzeppelin/contracts/utils/Counters.sol';

import 'hardhat/console.sol';

contract KBMarket is ReentrancyGuard {
    using Counters for Counters.Counters;

    /* number of items minting, number of transactions, tokens that have not been sold
    keep track of tokens total number - tokenId
    arrays need to know the length - help to keep track for arrays */

    Counters.Counter private _tokenIds;
    Counters.Counter private _tokensSold;

    // determine who is the owner of the contract
    // charge a listing fee so that the owner makes a commission

    address payable owner;
    // deploying ether to the matic API is basically the same as they both have 18 decimal
    uint256 listingPrice = 0.045 ether;

    constructor() {
        // setup the receiving founds to the owner' address
        owner = payable(msg.sender);
    }

    struct MarketToken {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketToken) private idToMarketToken;

    // listen to events from Frontend application
    event MarketTokenMinted(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    // get the listing price
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    // 1. Create a market item to put it for sale
    // 2. Create a market sale for buying and selling between parties

    function mintMarketItem(
        address nftContract,
        uint tokenId,
        uint256 price
    )
    public payable nonReentrant {
        // nonReentrant is a modifier to prevent reentry attack
        require(price > 0, 'Price must be at least one wei');
        require(msg.value == listingPrice, 'Price must be equal to listing price');

        _tokenIds.increment();
        uint itemId = _tokenIds.current();

        // putting the item up for sale
        idToMarketToken[itemId].sold = MarketToken(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        // NFT transaction - transfer the NFT to another account
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
    }
}