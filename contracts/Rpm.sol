// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AMZToken {
    string public name = "AMZ Token";//name & symbol are part of ERC20 implementaion, but are optional
    string public symbol = "AMZ";
    string public standard = "AMZ Token v1.0";//not the part of ERC20 implementation
    uint256 public totalSupply;

    uint public balanceOfSender;
    address public to;
    address public sender;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    //Approve
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _initialSupply) { 
        // balanceOf[msg.sender] = _initialSupply;
        // balanceOf[address(this)] = _initialSupply;
        totalSupply = _initialSupply; 
    }

    //Transfer
    function transfer(address _to, uint256 _value) public payable returns (bool success){
      balanceOfSender = balanceOf[msg.sender];
      //Exception if account does'nt have enough
      //require(balanceOf[msg.sender] >= _value, "Sender balance less");//Stop function if condition result false
    
      to = _to; 
      sender = msg.sender;  
      //   if (balanceOf[msg.sender] - _value >= 0)

      balanceOf[_to] += _value;

      emit Transfer(msg.sender, _to, _value);
      return true;
    }

    //Approve
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        
        return true;
    }
}

