// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CryptoBrews {
    uint256 public totalCoffee;
    address payable public owner;

    event NewCoffee(
        address indexed from,
        uint256 timestamp,
        string message,
        string name,
        uint256 amount
    );

    struct Coffee {
        address sender;
        string message;
        string name;
        uint256 timestamp;
        uint256 amount;
    }

    Coffee[] public coffee;

    constructor() payable {
        owner = payable(msg.sender);
    }

    function getAllCoffee() public view returns (Coffee[] memory) {
        return coffee;
    }

    function getTotalCoffee() public view returns (uint256) {
        return totalCoffee;
    }

    function buyCoffee(
        string memory _message,
        string memory _name,
        uint256 _amount
    ) public payable {
        require(
            msg.value == _amount,
            "You need to pay the exact specified amount"
        );

        totalCoffee += 1;
        coffee.push(
            Coffee(msg.sender, _message, _name, block.timestamp, _amount)
        );

        emit NewCoffee(msg.sender, block.timestamp, _message, _name, _amount);
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No balance to withdraw");
        (bool success, ) = owner.call{value: contractBalance}("");
        require(success, "Failed to send Ether to owner");
    }
}
