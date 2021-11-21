// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


contract Storage {

    struct Event {
        string title;
        uint256 price;
        string description;
        string image;
        uint256 seats;
        uint256 occupiedSeats;
    }
    
    mapping(address => Event[]) addressEventMap;
    
    event eventCreation (address indexed _owner, uint256 indexed _id);
    
    function createEvent(string calldata _title, uint256 _price, string calldata _description, string calldata _image, uint256 _seats, uint256 _occupiedSeats) public{
       
       Event memory _event = Event(
            _title,
            _price,
            _description,
            _image,
            _seats,
            _occupiedSeats
        );
        addressEventMap[msg.sender].push(_event);
        emit eventCreation(msg.sender, addressEventMap[msg.sender].length);
    }
    
    function viewEvent(address owner, uint256 _id) public view returns (Event memory _event) {
        return addressEventMap[owner][_id - 1];
    }
    
    function boughtTicket(address owner, uint256 _id) public {
        Event memory _event = addressEventMap[owner][_id - 1];
        require(_event.seats > _event.occupiedSeats, "Event is full");
        Event memory _tempEvent = Event(
        _event.title,
        _event.price,
        _event.description,
        _event.image,
        _event.seats,
        _event.occupiedSeats + 1
        );
        addressEventMap[owner][_id - 1] = _tempEvent;
    }
    
    
}