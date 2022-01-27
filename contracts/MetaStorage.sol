// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


contract MetaStorage {
    
    struct EventData {
        string title;
        string image;
        string link;
        uint256 fee;
        uint256 seats;
        uint256 occupiedSeats;
        string date;
        address childContract;
        string description;
        address eventHost;
    }

    mapping(address => EventData[]) detailsMap; 
    
    function getEventDetails() public view returns (EventData[]  memory _EventData) {
        return detailsMap[msg.sender];
    }

    function pushEventDetails(string memory title, uint256 fee, uint256 seats,uint256 occupiedSeats, string memory image, address eventHostAddress, string memory description, string memory link, string memory date, address child) public {
        EventData memory _tempEventData = EventData(
            title,
            image,
            link,
            fee,
            seats,
            occupiedSeats,
            date,
            child,
            description,
            eventHostAddress
        );
        detailsMap[eventHostAddress].push(_tempEventData);
    }
    
    
}
