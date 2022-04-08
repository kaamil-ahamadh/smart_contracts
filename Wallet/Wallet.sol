// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

contract Wallet {

    address public owner;
    bool _reEntrancy;

    event Deposit(address indexed _from, uint indexed _value);
    event Withdraw(address indexed _to, uint indexed _value);
    event OwnershipChange(address indexed _owner);

    constructor () {
        owner = msg.sender;
    }

    fallback() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier reEntrancyGuard() {
        require(!_reEntrancy, "Re-Entrancy Not Allowed");
        _reEntrancy = true;
        _;
        _reEntrancy = false;
    }


    function deposit() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(address payable _to, uint _value) external onlyOwner reEntrancyGuard {
        (bool success,) = _to.call{value: _value}("");
        require(success, "Withdrawal Failed");
        emit Withdraw(_to, _value);
    }

    function balanceOf() external view returns(uint) {
        return address(this).balance;
    }

    function changeOwner(address _owner) external onlyOwner {
        owner = _owner;
        emit OwnershipChange(_owner);
    }
}