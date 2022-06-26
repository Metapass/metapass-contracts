// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MetaStorage is Ownable {
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
        string venue;
    }

    struct HostProfile {
        string name;
        string profileImage;
        string bio;
        string socialLinks;
    }

    // Events

    event childCreated(
        string title,
        uint256 fee,
        uint256 seats,
        string image,
        address eventHost,
        string description,
        string link,
        string date,
        address childAddress,
        string category,
        address[] buyers,
        string venue
    );

    event TicketBought(address childContract, address buyer, uint256 tokenId);

    event HostCreated(
        address _hostAddress,
        string name,
        string image,
        string bio,
        string socialLinks
    );

    event CreateNewFeature(address featuredEventContract);

    event linkUpdate(address childContract, string link);

    // Contract Storage

    mapping(address => EventData[]) public detailsMap;
    mapping(address => HostProfile) public profileMap;
    address[] public featuredArray;
    address[] admins = [
        0x28172273CC1E0395F3473EC6eD062B6fdFb15940,
        0x0009f767298385f4Aa17EA1493562834657A2A5a
    ];
    modifier adminOnly() {
        require(msg.sender == admins[0] || msg.sender == admins[1]);
        _;
    }

    // Logic

    function getEventDetails()
        public
        view
        returns (EventData[] memory _EventData)
    {
        return detailsMap[msg.sender];
    }

    function pushEventDetails(
        string memory title,
        uint256 fee,
        uint256 seats,
        string memory image,
        address eventHostAddress,
        string memory description,
        string memory link,
        string memory date,
        address child,
        string memory category,
        string memory venue
    ) public {
        EventData memory _tempEventData = EventData(
            title,
            image,
            link,
            fee,
            seats,
            0,
            date,
            child,
            description,
            eventHostAddress,
            venue
        );
        detailsMap[eventHostAddress].push(_tempEventData);

        address[] memory emptyArr;

        emit childCreated(
            title,
            fee,
            seats,
            image,
            eventHostAddress,
            description,
            link,
            date,
            address(child),
            category,
            emptyArr,
            venue
        );
    }

    function emitTicketBuy(
        address _childContract,
        address _sender,
        uint256 _id
    ) public {
        emit TicketBought(_childContract, _sender, _id);
    }

    function emitLinkUpdate(address _event, string calldata _link) external {
        emit linkUpdate(_event, _link);
    }

    function createFeaturedEvent(address _event) public adminOnly {
        featuredArray.push(_event);
        emit CreateNewFeature(_event);
    }

    function addCreateHostProfile(
        string memory _name,
        string memory _image,
        string memory _bio,
        string memory _socialLinks
    ) public {
        HostProfile memory _tempProfile = HostProfile(
            _name,
            _image,
            _bio,
            _socialLinks
        );
        profileMap[msg.sender] = _tempProfile;
        emit HostCreated(msg.sender, _name, _image, _bio, _socialLinks);
    }

    function getRewards() public payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
