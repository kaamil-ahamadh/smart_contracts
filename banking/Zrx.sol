// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

//Importing Openzeppelin's ERC20 token contract for mocking ERC20 tokens
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';

//Zrx contract is inheriting from ERC20 contract
contract Zrx is ERC20 {

    //Giving name and symbol for ERC20 token
    constructor(uint256 _initialSupply) ERC20("0x", "ZRX") {
        
        //Minting tokens to msg.sender
        _mint(msg.sender, _initialSupply * 10 ** 18);
    }

}
