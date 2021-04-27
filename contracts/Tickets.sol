// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tickets is ERC721 {

    event Purchase(address indexed buyer, uint ticket_number);
    event Here1();
    event Here2();
    mapping(uint => address) IdxToHolder;

    struct TicketEvent {
        address TicketEventHolder;
        string TicketEventName;
        string URL;
        
        uint ticketPrice;
        uint maxSupply;
        //uint maxPurchaseAmount;

        uint numTicketsPurchased;

        bool[] ticketUsed;
    }

    event CreateEvent(uint eventIdx);

    TicketEvent[] private TicketEvents;
    mapping (address => uint) tokensOwnedByAddress;
    
    // Returns the index of all the TicketEvents that this owner owns in the "TicketEvents" array
    mapping (address => uint256[]) private TicketEventOwners;
    constructor() public ERC721("TicketEvent", "TKT") {}
    
    function transferTicket(address _to, uint _tokenID) public payable {
	require(address(0) != _to, "Invalid Address");
	transferFrom(msg.sender, _to, _tokenID);
    }

    function purchaseTicket(uint TicketEventIdx) public payable returns (bool) {
        TicketEvent storage thisTicketEvent = TicketEvents[TicketEventIdx];

        //require (quantity <= thisTicketEvent.maxPurchaseAmount, "Cannot purchase more than the maxPurchaseAmount for this ticket");
        require (thisTicketEvent.numTicketsPurchased < thisTicketEvent.maxSupply, "This TicketEvent has sold out of tickets");
        require (msg.value >= thisTicketEvent.ticketPrice, "Please send enough money");

        thisTicketEvent.numTicketsPurchased;
        
        //for (uint i = 0; i < quantity ; i++) {
        tokensOwnedByAddress[msg.sender] = thisTicketEvent.numTicketsPurchased;
	IdxToHolder[thisTicketEvent.numTicketsPurchased] = msg.sender;
        _mint(msg.sender, thisTicketEvent.numTicketsPurchased);
        thisTicketEvent.numTicketsPurchased++;
        //}

        emit Purchase(msg.sender, thisTicketEvent.numTicketsPurchased);

        return true;
    }

    function useTicket(uint TicketEventIdx, uint tokenId) public returns (bool) {
        TicketEvent storage thisTicketEvent = TicketEvents[TicketEventIdx];
        require (tokensOwnedByAddress[msg.sender] == tokenId, "You do not own this Token");
        require (thisTicketEvent.ticketUsed[tokenId] == false, "This ticket has already been used");
        _burn(tokenId);
	tokensOwnedByAddress[msg.sender] = 0;
	IdxToHolder[tokenId] = address(0);
        thisTicketEvent.ticketUsed[tokenId] = true;

        return true;
    }

    function createTicketEvent (string memory Name, string memory URL, uint Price, uint totalTkts) public returns (uint){
        TicketEvent memory ev1;
        ev1.TicketEventHolder = msg.sender;
        //ev1.TicketEventHolder : msg.sender,
        ev1.TicketEventName = Name;
        ev1.URL = URL;
        ev1.ticketPrice = Price;
        ev1.maxSupply = totalTkts;
       	//maxPurchaseAmount : maxBuy,
        ev1.numTicketsPurchased = 0;
        // });

        TicketEvents.push(ev1);
        uint TicketEventIdx = TicketEvents.length-1;

        TicketEventOwners[msg.sender].push(TicketEventIdx);

        emit CreateEvent(TicketEventIdx);

        return TicketEventIdx;
    }

    function destroyTicketEvent(uint TicketEventIndex) public payable {
    	require(msg.sender == TicketEvents[TicketEventIndex].TicketEventHolder, "You are not the TicketEvent holder");
	for(uint i=0; i < TicketEvents[TicketEventIndex].numTicketsPurchased; i++) {
		_burn(i);
		tokensOwnedByAddress[IdxToHolder[i]] = 0;
		IdxToHolder[i] = address(0);
	}
    }

    // helper functions
    function getTicketHolders(uint TicketEventIdx) public view returns (address[] memory) {
    	address[] memory  ticketHold;
    	for(uint i=0; i < TicketEvents[TicketEventIdx].numTicketsPurchased; i++) {
    		ticketHold[i] = IdxToHolder[i];
    	}
    	return ticketHold;
    }

    function getTicketEventInfo(uint TicketEventIdx) public view returns (string memory, string memory, uint, uint) {
    	return (TicketEvents[TicketEventIdx].TicketEventName, TicketEvents[TicketEventIdx].URL, TicketEvents[TicketEventIdx].ticketPrice, TicketEvents[TicketEventIdx].numTicketsPurchased);
    }
    
    function getTicketEvents() public view returns (TicketEvent[] memory) {
    	return TicketEvents;
    }
    

}
