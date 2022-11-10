// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./13_Rpm.sol";

contract AMZTokenSale {
    //We dont want to expose address of admin to public
    address payable private admin;
    AMZToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    uint public value;
    uint public tokenContractBalance;
    address public addressThis;

    event Sell(address _buyer, uint256 _amount);
    AMZToken _tokenContract  = AMZToken(0xC5862Ba753F3DabC4120E9803c01e0B13D7905F2); 
    constructor(
        // AMZToken _tokenContract, 
        uint256 _tokenPrice) { 
        admin = payable(msg.sender);
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
        // tokenContract.balanceOf[address(this)] = tokenContract.totalSupply;
    }

    // multiply
    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function buyTokens(uint256 _numberOfTokens) public payable {
        // Require that the value is equal to tokens
        require(msg.value == multiply(_numberOfTokens, tokenPrice), "Value Error");
        // Require that the contarct has enough tokens
        // require(tokenContract.balanceOf(address(this)) >= _numberOfTokens, "Balance Error 1");
        require(tokenContract.totalSupply() - tokensSold >= _numberOfTokens, "All tokens sold!");
        // Require that a transfer is successful
        require(tokenContract.transfer(msg.sender, _numberOfTokens), "Balance Error 2");
        // Keep track of tokenSold
        // tokenContract.transfer(msg.sender, _numberOfTokens);
        tokensSold += _numberOfTokens;

        emit Sell(msg.sender, _numberOfTokens);
    }
    // End Token Sale
    function endSale() public {
        // Require admin
        require(msg.sender == admin);
        // Transfer remaining tokens to admin
        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))));
        // Destroy contract
        selfdestruct(admin);
    }
}