// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//ERC Token Standard #20 Interface
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint balance);
    function allowance(address owner, address spender) external view returns (uint remaining);
    function transfer(address recipient, uint amount) external returns (bool success);
    function approve(address spender, uint amount) external returns (bool success);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}


//Actual token contract
contract DevUsdToken is ERC20Interface {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;


    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor(){
        symbol = 'DUSD';
        name = 'Dev Usd Token';
        decimals = 8;
        _totalSupply = 1_000_001_00; //A million + 1 token, with 8 zeros for decimal points
        balances[0x926087F1AD14c268e161D573eC1465315da3973f] = _totalSupply;
        emit Transfer(address(0), 0x926087F1AD14c268e161D573eC1465315da3973f, _totalSupply);
    }

    function totalSupply() override external view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) override external view returns (uint balance) {
        return balances[account];
    } 

    function transfer(address recipient, uint amount) override external returns (bool success){
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) override external returns (bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) override external returns (bool success){
        balances[sender] = balances[sender] - amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) override external view returns (uint remaining){
        return allowed[owner][spender];
    }
}
