//SPDX-License-Identifier: MIT


pragma solidity ^ 0.8.7;

contract Lottery{
    uint public minFee;
    address[] players;
    address public owner;
    mapping(address => uint) public playerBalance;

    constructor(uint _minFee){
        minFee = _minFee;
        owner = msg.sender;
    }

    function play() public payable minFeeToPay{
        
        players.push(msg.sender);
        playerBalance[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getRandomNumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyOwner{
        uint indice = getRandomNumber() % players.length;
        (bool success, ) = players[indice].call{value:getBalance()}("");
        require(success, "Fallo");
        players = new address[](0);

    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier minFeeToPay(){
        require(msg.value >= minFee, "Paga lo que debes");
        _;
    }
}
