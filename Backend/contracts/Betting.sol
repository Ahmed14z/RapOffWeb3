//SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;


//ownable contract from openzeppelin
import "@openzeppelin/contracts/access/Ownable.sol";

//LinkTokenInterface
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract Betting is Ownable {
    
    struct Bettors {
        address bettor;
        uint256 amountBet;
    }
    event bettorsEvent(address indexed bettor, uint256 amount);

    Bettors[] public bettorsArray;
    mapping(address => uint) public numBetsAddress;
    mapping(address => Bettors) public mapBettors;
    struct Rappers {
        string name;
        uint256 amountBetOn;
        address[] rapperBettors;
    }
    address link_token_contract = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    LinkTokenInterface LINKTOKEN = LinkTokenInterface(link_token_contract);

    //array of rappers
    Rappers[] public rappersArray;

    event RappersEvent(string indexed name);



    //this method 

    function setRapper(string memory _name) external onlyOwner {
        address[] memory rap;
        rappersArray.push(Rappers(_name, 0, rap));
        emit RappersEvent(_name);
    }

    function betOnRapper(uint256 _rapperIndex, uint256 amount) public {
        require(amount > 3, "you must bet with  3 link tokens");

        //the msg.sender must approve the contract
        LINKTOKEN.transferFrom(msg.sender, address(this), amount);

        bettorsArray.push(Bettors({bettor: msg.sender, amountBet: amount}));
        mapBettors[msg.sender] = Bettors({
            bettor: msg.sender,
            amountBet: amount
        });
        rappersArray[_rapperIndex].amountBetOn += amount;
        rappersArray[_rapperIndex].rapperBettors.push(msg.sender);
        numBetsAddress[msg.sender]++;

        emit bettorsEvent(msg.sender, amount);
    }

    function rapperWinFundDistribution(uint _rapperIndex) public onlyOwner {
        uint div;
        address bettorsAddress;
        uint256 userBet;
        uint256 winnerBet;
        uint256 loserBet;
        if (_rapperIndex == 0) {
            for (
                uint256 i = 0;
                i < rappersArray[_rapperIndex].rapperBettors.length;
                i++
            ) {
                bettorsAddress = rappersArray[_rapperIndex].rapperBettors[i];
                userBet = mapBettors[bettorsAddress].amountBet;
                winnerBet = rappersArray[0].amountBetOn;
                loserBet = rappersArray[1].amountBetOn;

                div =
                    (userBet * (10000 + ((loserBet * 10000) / winnerBet))) /
                    10000;
                LINKTOKEN.transfer(bettorsAddress, div);
            }
        }
        if (_rapperIndex == 1) {
            for (
                uint256 i = 0;
                i < rappersArray[_rapperIndex].rapperBettors.length;
                i++
            ) {
                bettorsAddress = rappersArray[_rapperIndex].rapperBettors[i];
                userBet = mapBettors[bettorsAddress].amountBet;
                winnerBet = rappersArray[1].amountBetOn;
                loserBet = rappersArray[0].amountBetOn;

                div =
                    (userBet * (10000 + ((loserBet * 10000) / winnerBet))) /
                    10000;
                LINKTOKEN.transfer(bettorsAddress, div);
            }
        }

        rappersArray[0].amountBetOn = 0;
        rappersArray[1].amountBetOn = 0;
    }
}
