//SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


//THIS IS THE OFFICIAL VOTING CONTRACT OF RAPOFFWEB3 
//SEPOLIA TESTNET

contract VotingContract is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter public _voterId;
    Counters.Counter public _rapperId;

    //creating an internal object of AggregatorV3Interface
    AggregatorV3Interface internal priceFeed;

    //Struct for Rapper
    struct Rapper {
        string name;
        uint256 rapperID;
        string image;
        string ipfs;
        address _address;
        uint256 voteCount;
    }
    //declare Rapper event
    event rapperEvent(
        uint256 indexed rapperID,
        string name,
        string image,
        string ipfs,
        address _address,
        uint256 voteCount
    );

    //create winner struct
    Rapper public Winner;

    //create the array of addresses of all rappers

    address[] public rapperAddresses;

    //map the uniqueID of the rapper to its struct
    mapping(address => Rapper) public rapperMapping;

    ///////END OF RAPPER DATA/////////

    address[] public voterAddresses; //maybe separate this to different arrays so as to use it for the betting platform

    //map the address of the rapper to its struct
    mapping(address => Voter) public voterMapping;

    struct Voter {
        string voter_name;
        uint256 voterID;
        bool voter_Voted;
        address voter_Address;
        string voter_Image;
        string voter_ipfs;
        uint256 voter_vote;
    }
    event VoterEvent(
        uint256 indexed voterID,
        string voter_name,
        bool voter_Voted,
        address voter_Address,
        string voter_Image,
        string voter_ipfs,
        uint256 voter_vote
    );

    //declaring the contract constructor

    constructor() {
        //SEPOLIA TESTNET- LINK/ETH
        priceFeed = AggregatorV3Interface(
            0x42585eD362B3f1BCa95c640FdFf35Ef899212734
        );
    }

    //initialize rapper
    function setRapper(
        address _address,
        string memory _image,
        string memory _ipfs,
        string memory _name
    ) public onlyOwner {
        //using counter library
        _rapperId.increment();
        uint256 idNumber = _rapperId.current();

        //map rapper address to its struct
        // Rapper storage rapper= rapperMapping[_address];?

        rapperMapping[idNumber] = Rapper(
            _name,
            idNumber,
            _image,
            _ipfs,
            _address,
            0
        );
        rapperAddresses.push(_address);
        emit rapperEvent(idNumber, _name, _image, _ipfs, _address, 0);
    }

    //function to return all rapper addresses
    function getRapperAddresses() public view returns (address[] memory) {
        return rapperAddresses;
    }

    function getTheNumberOfRappers() public view returns (uint256) {
        return rapperAddresses.length;
    }

    function getA_RapperData(address _rapperID)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            string memory,
            address,
            uint256
        )
    {
        Rapper storage rapper = rapperMapping[_rapperID];
        return (
            rapper.rapperID,
            rapper.name,
            rapper.image,
            rapper.ipfs,
            rapper._address,
            rapper.voteCount
        );
    }

    //returns latest price
    function getLatestPrice() public view returns (int) {
        (, int price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    //making vote function a public, payable function, 3 LINK worth of ETH--- LINK/ETH
    function voteNow(
        uint256 _rapperID,
        string memory _name,
        string memory _image,
        string memory _ipfs
    ) public payable {
        //will require 1 LINK token to vote
        require(
            msg.value >= getLatestPrice(),
            "1 LINK token is required to vote"
        );
        require(
            !voterMapping[msg.sender].voter_Voted,
            "sorry, you can only vote once"
        );

        //increment the vote for the chosen rapperID
        rapperMapping[_rapperID].voteCount += 1;
        //increment voter_ID
        _voterId.increment();
        uint256 voterIDNumber = _voterId.current();

        //mapped the voter address to its struct

        voterMapping[msg.sender] = Voter(
            _name,
            voterIDNumber,
            true,
            msg.sender,
            _image,
            _ipfs,
            _rapperID
        );
        voterAddresses.push(msg.sender);

        //emit voter event
        emit VoterEvent(
            voterIDNumber,
            _name,
            true,
            msg.sender,
            _image,
            _ipfs,
            _rapperID
        );
    }

    //this returns the number of voters
    function getNumberOfAllVoters() public view returns (uint256) {
        return voterAddresses.length;
    }



    //DO WE HAVE TO AUTOMATE THIS FUNCTION
    ///Determine the winner of the RAP BATTLE

    function callWinner() public onlyOwner {
        for (uint256 i = 0; i < rapperAddresses.length - 1; i++) {
            if (
                rapperMapping[rapperAddresses[i]].voteCount >=
                rapperMapping[rapperAddresses[i++]].voteCount
            ) {
                Winner = rapperMapping[rapperAddresses[i]];
            } else {
                Winner = rapperMapping[rapperAddresses[i++]];
            }
        }
    }
}
