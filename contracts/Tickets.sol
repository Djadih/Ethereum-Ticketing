// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tickets is ERC721 {

    mapping(uint => address) IdxToHolder;

    struct Event {
        address eventHolder;
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
    constructor() public ERC721("Event", "TKT") {}
    
    function transferTicket(address _to, uint _tokenID) public payable {
	require(address(0) != _to, "Invalid Address");
	transferFrom(msg.sender, _to, _tokenID);
    }

    function purchaseTicket(uint eventIdx) public payable returns (bool) {
        Event storage thisEvent = events[eventIdx];

        //require (quantity <= thisEvent.maxPurchaseAmount, "Cannot purchase more than the maxPurchaseAmount for this ticket");
        require (thisEvent.numTicketsPurchased < thisEvent.maxSupply, "This event has sold out of tickets");
        require (msg.value >= thisEvent.ticketPrice, "Please send enough money");

        thisEvent.numTicketsPurchased;
        
        //for (uint i = 0; i < quantity ; i++) {
        tokensOwnedByAddress[msg.sender] = thisEvent.numTicketsPurchased;
	IdxToHolder[thisEvent.numTicketsPurchased] = msg.sender;
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
	tokensOwnedByAddress[msg.sender]--;
	IdxToHolder[tokenId] = address(0);
        thisEvent.ticketUsed[tokenId] = true;

        return true;
    }

    function createEvent (string memory Name, string memory URL, uint Price, uint totalTkts) public returns (uint){
        Event memory ev1;
        ev1.eventHolder = msg.sender;
        //ev1.eventHolder : msg.sender,
        ev1.eventName = Name;
        ev1.URL = URL;
        ev1.ticketPrice = Price;
        ev1.maxSupply = totalTkts;
       	//maxPurchaseAmount : maxBuy,
        ev1.numTicketsPurchased = 0;
        // });

        events.push(ev1);
        uint eventIdx = events.length-1;

        eventOwners[msg.sender].push(eventIdx);
        return eventIdx;
    }

    function destroyEvent(uint eventIndex) public payable {
    	require(msg.sender == events[eventIndex].eventHolder, "You are not the event holder");
	for(uint i=0; i < events[eventIndex].numTicketsPurchased; i++) {
		_burn(i);
		tokensOwnedByAddress[IdxToHolder[i]] = 0;
		IdxToHolder[i] = address(0);
	}
    }

    // helper functions
    function getTicketHolders(uint eventIdx) public view returns (address[] memory) {
    	address[] memory  ticketHold;
    	for(uint i=0; i < events[eventIdx].numTicketsPurchased; i++) {
    		ticketHold[i] = IdxToHolder[i];
    	}
    	return ticketHold;
    }

    function getEventInfo(uint eventIdx) public view returns (string memory, string memory, uint, uint) {
    	return (events[eventIdx].eventName, events[eventIdx].URL, events[eventIdx].ticketPrice, events[eventIdx].numTicketsPurchased);
    }
    
    function getEvents() public view returns (Event[] memory) {
    	return events;
    }
    

}
