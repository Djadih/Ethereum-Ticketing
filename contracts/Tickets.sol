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

    TicketEvent private TicketEvents;
    mapping (address => uint) tokensOwnedByAddress;
    
    // Returns the index of all the TicketEvents that this owner owns in the "TicketEvents" array
    mapping (address => uint256[]) private TicketEventOwners;
    constructor() public ERC721("TicketEvent", "TKT") {}
    
    function transferTicket(address _to, uint _tokenID) public payable {
	require(address(0) != _to, "Invalid Address");
	transferFrom(msg.sender, _to, _tokenID);
    }

    function purchaseTicket(uint TicketEventIdx) public payable returns (bool) {
        TicketEvent storage thisTicketEvent = TicketEvents;

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
        // TicketEvent storage thisTicketEvent = TicketEvents[TicketEventIdx];
        require (tokensOwnedByAddress[msg.sender] == tokenId, "You do not own this Token");
        // require (thisTicketEvent.ticketUsed[tokenId] == false, "This ticket has already been used");
        _burn(tokenId);
	    tokensOwnedByAddress[msg.sender] = 0;
	    IdxToHolder[tokenId] = address(0);
        TicketEvents.ticketUsed[tokenId] = true;

        return true;
    }

    function createTicketEvent (string memory Name, string memory URL, uint Price, uint totalTkts) public returns (uint){

        // require (TicketEvents.TicketEventHolder == msg.sender || TicketEvents.TicketEventHolder == address(0));
        require (TicketEvents.TicketEventHolder == address(0), "There is currently an active event. Cancel this first");

        TicketEvent memory ev1;
        ev1.TicketEventHolder = msg.sender;
        //ev1.TicketEventHolder : msg.sender,
        ev1.TicketEventName = Name;
        ev1.URL = URL;
        ev1.ticketPrice = Price;
        ev1.maxSupply = totalTkts;
       	//maxPurchaseAmount : maxBuy,
        ev1.numTicketsPurchased = 0;
        ev1.ticketUsed = new bool[](totalTkts);

        TicketEvents = ev1;
        uint TicketEventIdx = 0;

        // TicketEventOwners[msg.sender].push(TicketEventIdx);

        emit CreateEvent(TicketEventIdx);

        return TicketEventIdx;
    }

    function destroyTicketEvent(uint TicketEventIndex) public payable {
    	require(msg.sender == TicketEvents.TicketEventHolder, "You are not the TicketEvent holder");
        for(uint i=0; i < TicketEvents.numTicketsPurchased; i++) {
            if (!TicketEvents.ticketUsed[i]) {
                _burn(i);
                tokensOwnedByAddress[IdxToHolder[i]] = 0;
                IdxToHolder[i] = address(0);
            }
        }

        TicketEvent memory ev1;
        ev1.TicketEventHolder = address(0);
        //ev1.TicketEventHolder : msg.sender,
        ev1.TicketEventName = '';
        ev1.URL = '';
        ev1.ticketPrice = 0;
        ev1.maxSupply = 0;
        ev1.numTicketsPurchased = 0;
        ev1.ticketUsed = new bool[](0);
        

        TicketEvents = ev1;

    }

}
