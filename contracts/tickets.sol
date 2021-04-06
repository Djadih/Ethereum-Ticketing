// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tickets is ERC721 {

    mapping(uint => address) IdxtoHolder;

    struct Event {
        address payable eventHolder;
        string eventName;
        string URL;
        
        uint ticketPrice;
        uint maxSupply;
        //uint maxPurchaseAmount;

        uint numTicketsPurchased;

        bool[] ticketUsed;
    }

    Event[] private events;
    mapping (address => uint) tokensOwnedByAddress;

    // Returns the index of all the events that this owner owns in the "events" array
    mapping (address => uint256[]) private eventOwners;

    function transferTicket(address _to, uint _quantity) public payable;

    function purchaseTicket(uint eventIdx, uint quantity) public payable returns (bool) {
        Event storage thisEvent = events[eventIdx];

        //require (quantity <= thisEvent.maxPurchaseAmount, "Cannot purchase more than the maxPurchaseAmount for this ticket");
        require (thisEvent.numTicketsPurchased < thisEvent.maxSupply, "This event has sold out of tickets");
        require (msg.value >= thisEvent.ticketPrice, "Please send enough money");

        thisEvent.numTicketsPurchased;
        
        //for (uint i = 0; i < quantity ; i++) {
        tokensOwnedByAddress[msg.sender] = thisEvent.numTicketsPurchased;
        _mint(msg.sender, thisEvent.numTicketsPurchased);
        thisEvent.numTicketsPurchased++;
        //}

        return true;
    }

    function useTicket(uint eventIdx, uint tokenId) public returns (bool) {
        Event storage thisEvent = events[eventIdx];
        require (tokensOwnedByAddress[msg.sender] == tokenId, "You do not own this Token");
        require (thisEvent.ticketUsed[tokenId] == false, "This ticket has already been used");

        _burn(tokenId);

        thisEvent.ticketUsed[tokenId] = true;

        return true;
    }

    function createEvent (string memory Name, string memory URL, uint Price, uint totalTkts, uint maxBuy) public {
        Event memory ev1;
        ev1.eventHolder = msg.sender;
        // // ticketHolders : address[totalTkts],
        // eventHolder : msg.sender,
        // eventName : Name,
        // URL : URL,
        // ticketPrice : Price,
        // maxSupply : totalTkts,
        // //maxPurchaseAmount : maxBuy,
        // numTicketsPurchased : 0
        // });

        events.push(ev1);
        uint eventIdx = events.length-1;

        eventOwners[msg.sender].push(eventIdx);
    }

    function destroyEvent() public payable;

    // helper functions
    //function getTicketHolders();

    // function ownerOnly returns bool();

}
