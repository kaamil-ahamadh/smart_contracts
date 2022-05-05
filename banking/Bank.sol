//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

//Importing Openzeppelin's IERC20 interface for interacting with Mock ERC20 tokens
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract Bank {
    //admin
    address admin;

    //Whitelisted Tokens Registry
    bytes32[] _whiteListedSymbols;
    mapping(bytes32 => address) _whitelistedTokens;

    //User Balance of whitelisted Tokens
    mapping(address => mapping(bytes32 => uint)) public balanceOf;

    //Initialization of admin to deployer of this contract
    constructor() {
        admin = msg.sender;
    }

    //Access Control
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only Admin can call this function");
        _;
    }

    /**
     * @notice Whitelist tokens for enabling deposit into this contract
     */
    function whitelistToken(bytes32 _symbol, address _tokenAddress) external onlyAdmin {
        _whiteListedSymbols.push(_symbol);
        _whitelistedTokens[_symbol] = _tokenAddress;
    }

    /**
     * @notice List out all whitelisted token symbols
     */
    function getWhiteListedSymbols() external view returns(bytes32[] memory) {
        return _whiteListedSymbols;
    }
    
    /**
     * @notice Get whitelisted token address from whitelisted token symbol
     */
    function getWhiteListedTokenAddress(bytes32 _symbol) external view returns(address) {
        return _whitelistedTokens[_symbol];
    }

    /**
     * @notice Deposit Ether into this contract directly from a contract address
     */
    receive() external payable {
        balanceOf[msg.sender]['ETH'] += msg.value;
    }

    /**
     * @notice Withdraw already deposited ether upto the maximum amount of his balance
     */
    function withdrawEther(uint _amount) external {
        require(balanceOf[msg.sender]['ETH'] >= _amount, "Insufficient ether");

        balanceOf[msg.sender]['ETH'] -= _amount;
        (bool success,) = payable(msg.sender).call{value : _amount}('');
        require(success, "Failed to withdraw ether");
    }

    /**
     * @notice Deposit whitelisted ERC20 tokens into this contract
     */
    function depositERC20Token(bytes32 _symbol, uint _amount) external {
        balanceOf[msg.sender][_symbol] += _amount;
        IERC20(_whitelistedTokens[_symbol]).transferFrom(msg.sender, address(this), _amount);
    }


    /**
     * @notice Withdraw already deposited ERC20 tokens upto the maximum amount of his balance
     */
    function withdrawERC20Token(bytes32 _symbol, uint _amount) external {
        require(balanceOf[msg.sender][_symbol] >= _amount, "Insufficient Tokens");

        balanceOf[msg.sender][_symbol] -= _amount;
        IERC20(_whitelistedTokens[_symbol]).transfer(msg.sender, _amount);
    }
}
