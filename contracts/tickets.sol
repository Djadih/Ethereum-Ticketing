// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tickets is ERC721 {

    mapping(uint => address) IdxtoHolder;



    constructor() ERC721(ticketHolders, ) {
    }

    struct ticket {
        address ticketHodler;
        string eventName;
        bool sold;
        bool used;
    }

    struct Event {
        address[] ticketHodlers;
        address payable eventHolder;
        string eventName;
        string URL;
        
        uint ticketPrice;
        uint numLeft;
        uint maxPurchase;
    }

    function purchaseTicket() public payable {

    }

}