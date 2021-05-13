// SPDX-License-Identifier: MIT
pragma solidity ^0.5.6;

contract RSVP {

    address payable public owner;

    struct Event {
        string name;
        string date;
        uint256 price;
        mapping(address => bool) rsvpers;
        address[] attendees;
    }

    mapping(uint256 => Event) events;
    uint256 public eventIdTracker;

    event EventCreated(string name, string date, uint256 price);
    event UserRSVPed(address user, uint256 eventId);
    event AttendanceMarked(address attendee, uint256 evt);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function createEvent(
        string memory _name,
        string memory _date,
        uint256 _price
    ) public onlyOwner returns (uint256 _eventId) {
        Event memory newEvent;
        newEvent.name = _name;
        newEvent.date = _date;
        newEvent.price = _price;
        _eventId = eventIdTracker;
        eventIdTracker++;
        events[_eventId] = newEvent;

        emit EventCreated(_name, _date, _price);
    }

    function getEventDetails(uint256 _eventId)
        public
        view
        returns (
            string memory _name,
            string memory _date,
            uint256 _price
        )
    {
        _name = events[_eventId].name;
        _date = events[_eventId].date;
        _price = events[_eventId].price;
    }

    function rsvpForEvent(uint256 _eventId) public payable {
      
      if (msg.value > events[_eventId].price){
        msg.sender.transfer(events[_eventId].price);
      }
        events[_eventId].rsvpers[msg.sender] = true;

        emit UserRSVPed(msg.sender, _eventId);
    }

    function markAttended(uint256 _eventId, address _attendee)
        public
        onlyOwner
    {
        if (events[_eventId].rsvpers[_attendee]) {
            events[_eventId].attendees.push(_attendee);
        } 
    }
}
