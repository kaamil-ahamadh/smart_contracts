//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract Bank {
    //admin
    address admin;

    //Whitelisted Tokens Registry
    bytes32[] _whiteListedSymbols;
    mapping(bytes32 => address) _whitelistedTokens;

    //User Balance of whitelisted Tokens
    mapping(address => mapping(bytes32 => uint)) public balanceOf;


    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only Admin can call this function");
        _;
    }

    //Add whitelistTokens by admin
    function whitelistToken(bytes32 _symbol, address _tokenAddress) external onlyAdmin {
        _whiteListedSymbols.push(_symbol);
        _whitelistedTokens[_symbol] = _tokenAddress;
    }

    function getWhiteListedSymbols() external view returns(bytes32[] memory) {
        return _whiteListedSymbols;
    }

    function getWhiteListedTokenAddress(bytes32 _symbol) external view returns(address) {
        return _whitelistedTokens[_symbol];
    }

    //Deposit Ether
    receive() external payable {
        balanceOf[msg.sender]['ETH'] += msg.value;
    }

    //Withdraw Ether
    function withdrawEther(uint _amount) external {
        require(balanceOf[msg.sender]['ETH'] >= _amount, "Insufficient ether");

        balanceOf[msg.sender]['ETH'] -= _amount;
        (bool success,) = payable(msg.sender).call{value : _amount}('');
        require(success, "Failed to withdraw ether");
    }

    //Deposit ERC20 Tokens
    function depositERC20Token(bytes32 _symbol, uint _amount) external {
        balanceOf[msg.sender][_symbol] += _amount;
        IERC20(_whitelistedTokens[_symbol]).transferFrom(msg.sender, address(this), _amount);
    }


    //Withdraw ERC20 Tokens
    function withdrawERC20Token(bytes32 _symbol, uint _amount) external {
        require(balanceOf[msg.sender][_symbol] >= _amount, "Insufficient Tokens");

        balanceOf[msg.sender][_symbol] -= _amount;
        IERC20(_whitelistedTokens[_symbol]).transfer(msg.sender, _amount);
    }
}
