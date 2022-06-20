// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract WavePortal is Ownable {
    using SafeMath for uint256;
    uint256 totalWaves;
    mapping (address => uint) public lastWavedAt;
    // event to broadcast a New Wave 
    event NewWave(address indexed from, uint256 timestamp, string message);

    // A struct is basically a custom datatype where we can customize what we want to hold inside it.

    struct Wave {
        address waver; // address of person who waved
        string message; // message they sent
        uint256 timestamp; // Time they sent
    }

    Wave[] waves;

    constructor() payable {
        console.log("We have been constructed!");
    }

    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);
        // array to store waves
        waves.push(Wave(msg.sender, _message, block.timestamp));
        emit NewWave(msg.sender, block.timestamp, _message);

        uint256 prizeAmount = 0.0001 ether;
        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract");
        require(lastWavedAt[msg.sender] + 10 minutes < block.timestamp, "Must wait 30 seconds before waving again.");
        
    }

    function getAllWaves() public view returns(Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns(uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
} 