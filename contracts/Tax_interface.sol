interface Tax_interface{
	//向订单征税
    function Tax_order() public;
	//计算税值
    function Calculation_tax(address Order_address) public view returns(uint256);
	//从税收合约中取款
    function withdraw() public;
}