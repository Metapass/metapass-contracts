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

    struct HostProfile {
        string name;
        string profileImage;
        string bio;
        string socialLinks;
    }

    // Events

    event childCreated(string title, uint256 fee, uint256 seats, string image, address eventHost, string description, string link, string date, address childAddress);

    event TicketBought (address childContract, address buyer);
    
    event HostCreated (address _hostAddress, string name, string image, string bio, string socialLinks);

    event CreateNewFeature (address featuredEventContract);

    // Contract Storage

    mapping(address => EventData[]) detailsMap; 
    mapping(address => HostProfile) profileMap;
    address[] featuredArray;
    address[] admins = [0x28172273CC1E0395F3473EC6eD062B6fdFb15940, 0x0009f767298385f4Aa17EA1493562834657A2A5a];
    modifier adminOnly {
        require(msg.sender == admins[0] || msg.sender == admins[1]); //same as the if above
        _; //tells that this modifier should be executed before the code
    }
    // Logic

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
        
        emit childCreated(title, fee, seats, image, eventHostAddress, description, link, date, address(child));
    }

    function emitTicketBuy(address _childContract, address _sender) public {
        emit TicketBought(_childContract, _sender);
    }

  /*  function isAdmin(address _address) public view returns (bool _isAdmin) {
        
        bool boolean = false;

        for(uint i = 0; i< admins.length; i++) {
            if(_address == admins[i]) {
                boolean = true;
            } else {
                boolean = false;
            }
        }

        return boolean;
    } */

    function createFeaturedEvent(address _event) public adminOnly {
        //require(isAdmin(msg.sender), "Unauthorized user");
        featuredArray.push(_event);
        emit CreateNewFeature(_event);
    }

    function addCreateHostProfile(string memory _name, string memory _image, string memory _bio, string memory _socialLinks) public {
        HostProfile memory _tempProfile = HostProfile(
            _name,
            _image,
            _bio,
            _socialLinks
        );
        profileMap[msg.sender] = _tempProfile;
        emit HostCreated(msg.sender, _name, _image, _bio, _socialLinks);
    }

}
}
