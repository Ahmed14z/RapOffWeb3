// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File @openzeppelin/contracts/access/Ownable.sol@v4.8.3

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol@v0.6.1

pragma solidity ^0.8.0;

interface LinkTokenInterface {
    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining);

    function approve(address spender, uint256 value)
        external
        returns (bool success);

    function balanceOf(address owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8 decimalPlaces);

    function decreaseApproval(address spender, uint256 addedValue)
        external
        returns (bool success);

    function increaseApproval(address spender, uint256 subtractedValue)
        external;

    function name() external view returns (string memory tokenName);

    function symbol() external view returns (string memory tokenSymbol);

    function totalSupply() external view returns (uint256 totalTokensIssued);

    function transfer(address to, uint256 value)
        external
        returns (bool success);

    function transferAndCall(
        address to,
        uint256 value,
        bytes calldata data
    ) external returns (bool success);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool success);
}

// File contracts/Betting.sol

pragma solidity ^0.8.9;

contract Betting is Ownable {
    //how to calculate the stake in each betting
    //the user will enter the amount they wanna bet in LINK token
    //place a bet
    //the contract has to know who won
    //send the money to the bettors who staked on the winner
    //https://www.figma.com/proto/ke1gjWSQR4M446ixf3mT2g/Gideon?node-id=7788%3A67826&scaling=min-zoom



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

    function setRapper(string memory _name) external onlyOwner {
        address[] memory rap;
        rappersArray.push(Rappers(_name, 0, rap));
        emit RappersEvent(_name);
    }

    function betOnRapper(uint256 _rapperIndex, uint256 amount) public {
        require(amount > 0, "you must bet with some link token");

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
                winnerBet = rappersArray[_rapperIndex].amountBetOn;
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
                winnerBet = rappersArray[_rapperIndex].amountBetOn;
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
