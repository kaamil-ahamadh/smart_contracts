// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

contract BasicToken {
    address public minter;

    string public name;
    string public symbol;
    uint public totalSupply;

    mapping(address => uint) public balanceOf;

    bool reEntrancy;

    event Mint(address indexed _from,address indexed _to, uint indexed _value);
    event Burn(address indexed _from, address indexed _to, uint indexed _value);
    event Sent(address indexed _from, address indexed _to, uint indexed _value);

    constructor(string memory _name, string memory _symbol, uint _totalSupply) {
        minter = msg.sender;
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        balanceOf[minter] = _totalSupply;
    }

    modifier onlyMinter() {
        require(msg.sender == minter, "only minter can call this function");
        _;
    }

    modifier reEntrancyGuard() {
        require(!reEntrancy, "Re-Entrancy Attacks not Allowed");
        reEntrancy = true;
        _;
        reEntrancy = false;
    }

    function mint(address _to, uint _value) external onlyMinter {
        require(_to != address(0), "You can't mint for zero address.");
        balanceOf[_to] += _value;

        totalSupply += _value;
        emit Mint(address(0),_to, _value);
    }

    function send(address _to, uint _value) external reEntrancyGuard {
        require(balanceOf[msg.sender] >= _value, "Not enough balance");
        require(_to != address(0), "You can't send to zero address.");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Sent(msg.sender, _to, _value);
    }

    function burn(uint _value) external {
        require(balanceOf[msg.sender] >= _value, "Not enough balance");
        balanceOf[msg.sender] -= _value;

        totalSupply -= _value;

        emit Burn(msg.sender, address(0), _value);
    }
}