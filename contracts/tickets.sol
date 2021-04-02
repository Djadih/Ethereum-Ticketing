// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tickets is ERC721 {

    mapping(uint => address) IdxtoHolder;

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

    Event ev1;

    modifier onlyOwner() {
        require(msg.sender == venueOwner);
        _;
    }

    modifier notOwner() {
        require(msg.sender != venueOwner);
        _;
    }

    function purchaseTicket() public payable {
    }

    constructor(address payable Holder, string Name, string URL, uint Price, uint totalTkts, uint maxBuy) ERC721MetaData("Tickets", "TKT") ERC721() {
        ev1.eventHolder = Holder;
        ev1.eventName = Name;
        ev1.URL = URL;
        ev1.ticketPrice = Price;
        ev1.numLeft = totalTkts;
        ev1.maxPurchase = maxBuy;
    }

}
