

interface Order_interface{

	//设置废品数量/重量
	function set_order_weight (uint a,uint b,uint c,uint d,uint e,uint f)public ;
	
	//设置废品价格
    function set_order_prize (uint a1,uint b1,uint c1,uint d1,uint e1,uint f1)public;
	
	//总价格计算
	function calculate_order_prize() public returns (uint256) ;
	
	//订单开始
    function start_order(string _phone_number,string _city,string _district,string _street,string _community,string _acc_location ) public ;
    
    //接单
    function recive_order() public;
    
	//公司上门回收,（可能）修改订单
	function order_modify();
	
	//用户确定
	function order_comfirm_by_seller() public;

	//买家汇款后，订单结束
	function order_comfirm_by_buyer() payable public;
	

    //隐藏信息,只有接单的人可以获得隐藏信息，精确地址和手机号码
	function private_message() public returns (string ,string);
	
	//从订单中提款
    function withdraw_by_owner() public ;
	
	//获取赞助
	function revice_spornor(address address_of_sponsor) public returns(uint256);
	
	//获取卖家区块链地址
	function get_owner() view public returns(address);
	
	//获得买家区块链地址
	function get_buyer() view public returns(address);
	
	//获得城市
	function get_city() view public returns(string);
	
	//获得区
	function get_district() view public returns(string);

	//获得街区
	function get_street() view public returns(string);
	
	//获得社区
	function get_community() view public returns(string);
	
	//获得订单状态
	function get_order_comfirm_status() view public returns(uint);
	
	//获得订单最终价格
	function get_order_prize() view public returns(uint256);
	
	//获得第a号废品的重量/数量
	function get_waste_list(uint a) view public returns(uint);
    
	//获得第a号废品的价格
    function get_waste_prize_list(uint b) view public returns(uint);

}
