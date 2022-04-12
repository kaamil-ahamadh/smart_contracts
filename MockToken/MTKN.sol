// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

contract MTKN {

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply * (10 ** _decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed _from, address indexed _to, uint _value);

    function transfer(address _to, uint _value) public returns(bool success) {
        require(balanceOf[msg.sender] >= _value, "Not Enough Tokens");
        require(_to != address(0), "Transfer of tokens to zero address is not allowed");
        require(msg.sender != address(0), "Transfer of tokens from zero address is not allowed");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }

    function approve(address _spender, uint _value) public returns(bool success) {
        require(_spender != msg.sender, "_spender and _owner cannot be a same address");
        require(_spender != address(0), "Approval of tokens to zero address is not allowed");
        require(msg.sender != address(0), "Approval of tokens to zero address is not allowed");
        
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns(bool success) {
        require(allowance[_from][msg.sender] >= _value, "Not enough allowance");
        require(balanceOf[_from] >= _value, "Not Enough tokens on owner account");
        require(_to != address(0), "Transfer of tokens to zero address is not allowed");
        require(_from != address(0), "Transfer of tokens from zero address is not allowed");

        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function burn(uint _value) public returns(bool success) {
        require(msg.sender != address(0), "Burning of Tokens from Zero Address is not Allowed");
        require(balanceOf[msg.sender] >= _value, "Not enough tokens");

        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        emit Transfer(msg.sender, address(0), _value);
        emit Burn(msg.sender, address(0), _value);

        return true;
    }
}