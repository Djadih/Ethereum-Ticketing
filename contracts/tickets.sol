// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tickets is ERC721 {

    mapping(uint => address) IdxtoHolder;

    struct Event {
        address [] ticketHolders;
        address payable eventHolder;
        string eventName;
        string URL;
        
        uint ticketPrice;
        uint maxSupply;
        uint maxPurchaseAmount;

        uint numTicketsPurchased;

        mapping (address => uint[]) tokensOwnedByAddress;
    }

    Event[] private events;

    // Returns the index of all the events that this owner owns in the "events" array
    mapping (address => uint256[]) private eventOwners;

    function transferTicket(address _to, uint _quantity) public payable {

    }

    function invalidateTicket() {

    }

    function purchaseTicket(uint eventIdx, uint quantity) public payable returns (bool) {
        Event thisEvent = events[eventIdx];

        require (quantity <= thisEvent.maxPurchaseAmount, "Cannot purchase more than the maxPurchaseAmount for this ticket");
        require (thisEvent.numTicketsPurchased < thisEvent.maxSupply, "This event has sold out of tickets");
        require (msg.value >= thisEvent.ticketPrice.mul(quantity), "Please send enough money");

        thisEvent.numTicketsPurchased;
        
        for (uint i = 0; i < thisEvent ; i++) {
            _mint(msg.sender, thisEvent.numTicketsPurchased);
            thisEvent.numTicketsPurchased++;
        }

        thisEvent.ticketHolders.push(msg.sender);

        return true;
    }

    function useTicket(uint tokenId) public {
        require (tokensOwnedByAddress[msg.sender])


        _burn(tokenId);
    }

    function createEvent (string memory Name, string memory URL, uint Price, uint totalTkts, uint maxBuy) public {
        Event memory ev1 = Event({
        ticketHolders : address[totalTkts],
        eventHolder : msg.sender,
        eventName : Name,
        URL : URL,
        ticketPrice : Price,
        maxSupply : totalTkts,
        maxPurchaseAmount : maxBuy,
        numTicketsPurchased : 0
        });

        uint eventIdx = events.push(ev1);
        eventOwners[msg.sender].push(eventIdx);

        eventToStartingTokenID[eventIdx] = 

        // Mint the maximum supply of tokens all at once
        mintTokens(eventIdx);
    }

    // helper functions
    function getTicketHolders();

    // function ownerOnly returns bool();

}
