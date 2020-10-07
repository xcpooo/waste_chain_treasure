pragma solidity ^0.4.25;
interface Token_interface {
    // token transfer internal function
    function _transfer(address _from, address _to, uint256 _value) ;
	
    // 从当前调用者（或智能合约）的地址向_to地址转账
    function transferTo(address _to, uint256 _value) public returns(bool success) ;
	
	//授权允许从当前调用者（或智能合约）的地址向_spender地址转账（未转账）
    function approve(address _spender, uint256 _value) public returns (bool success);

	//从_from地址向_to地址转账
    function transferFrom(address _from, address _to, uint256 _value) payable public returns(bool success);

	//销毁当前调用者（或智能合约）一定数值的token
    function burn(uint256 _value) public returns (bool success);

	//销毁_from地址一定数值的token
    function burnFrom(address _from, uint256 _value) public returns (bool success);
    
	//查询account地址的存款
    function getBalanceOf(address account) public returns(uint256);
    
	//查询_from地址对_to地址授权的可转账金额的数目
    function getAllowanceOf(address _from,address _to) public returns(uint256);
}
