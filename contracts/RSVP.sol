// SPDX-License-Identifier: MIT
pragma solidity ^0.5.6;

contract RSVP {

  address payable public owner;
  uint public eventIdTracker;

  struct Event {
    string name;
    string date;
    uint price;
    uint capacity;
  }

  mapping (uint => Event) events;
  event EventCreated(string name, string date, uint price, uint capacity);

  constructor() public {
    owner = msg.sender;
  }

  function createEvent(string memory _name, string memory _date, uint _price, uint _capacity) public returns(uint _eventId) {
    //Refactor and create function modifier called isOwner later
    require (msg.sender == owner);

    Event memory newEvent;
    newEvent.name = _name;
    newEvent.date = _date;
    newEvent.price = _price;
    newEvent.capacity = _capacity;

  _eventId = eventIdTracker;
  eventIdTracker++;
  events[_eventId] = newEvent;

  emit EventCreated(_name,_date,_price,_capacity);
  }

  function getEventDetails (uint _eventId) public view returns(string memory _name, string memory _date, uint _price, uint _capacity) {
    Event memory foundEvent = events[_eventId];
    _name = foundEvent.name;
    _date = foundEvent.date;
    _price = foundEvent.price;
    _capacity = foundEvent.capacity;
  }


}
