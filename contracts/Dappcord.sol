// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract Dappcord is ERC721{

    struct Channel{
        uint256 id;
        string name;
        uint256 cost;
        // address owner;
    }

    address public owner; //owner of the contract
    uint256 public channelCount = 0; //number of channels
    uint256 public totalysupply=0;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can create channels");
        _;
    }

    mapping (uint256 => Channel) public channels; //mapping of channel id to channel struct

    mapping(uint256=>mapping(address=>bool)) public hasJoined; //mapping of channel id to mapping of address to bool

    constructor (string memory name, string memory symbol) ERC721(name, symbol) {
        owner = msg.sender;

    } //constructor

    function createchannel(string memory _name, uint256 _cost) public onlyOwner{
        channelCount++;
        channels[channelCount]=Channel (channelCount,_name,_cost);
        
    }

    function getChannel (uint256 _id) public view returns (Channel memory){
    return channels[_id];        
    }

    function mint(uint256 _id) public payable{
        require(_id!=0);
        require(_id<=channelCount);
        require(hasJoined[_id][msg.sender]==false); //check if user has already joined
        require(msg.value>=channels[_id].cost); //check if user has paid the cost
        //join channel
        hasJoined[_id][msg.sender]=true;

        //Mint NFT 
        totalysupply++;
        _safeMint(msg.sender, totalysupply);
    }

    function withdraw() public onlyOwner{
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }


}

