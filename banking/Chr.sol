// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';

contract Chr is ERC20 {

    constructor(uint256 _initialSupply) ERC20("Chromia", "CHR") {
        _mint(msg.sender, _initialSupply * 10 ** 18);
    }

}