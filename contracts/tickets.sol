// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tickets is ERC721 {

    mapping(uint => address) IdxtoHolder;

    struct ticket {
        address ticketHolder;
        string eventName;
        bool sold;
        bool used;
    }

    struct Event {
        address [] tickerHolders;
        address payable eventHolder;
        string eventName;
        string URL;
        
        uint ticketPrice;
        uint numLeft;
        uint maxPurchase;
    }

    Event[] private events;

    // Returns the index of all the events that this owner owns in the "events" array
    mapping (address => uint256[]) private eventOwners;

    function mintTokens() public;

    function purchaseTicket() public payable;

    function useTicekt() public;

    function createEvent (string memory Name, string memory URL, uint Price, uint totalTkts, uint maxBuy) {
        Event memory ev1 = Event({
        tickerHolders: address[totalTkts],
        eventHolder : msg.sender,
        eventName : Name,
        URL : URL,
        ticketPrice : Price,
        numLeft : totalTkts,
        maxPurchase : maxBuy
        });

        uint id = events.push(ev1);
        eventOwners[msg.sender].push(id);
    }

    // helper functions
    function getTicketHolders();

    // function ownerOnly returns bool();

}
