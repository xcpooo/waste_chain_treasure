import "./Token_interface.sol";
import "./Order_interface.sol";
import "./Sponsor_interface.sol";
import "./Tax_interface.sol";
import "./Supervise_interface.sol";
import "./config.sol";
import "./Table.sol";
pragma solidity ^0.4.25;


contract Order is Order_interface,config{
    address token_address=config_tax_address;
	//token地址为RMB地址
    address Tax_address=config_tax_address;
	//tax地址为广州税务局的部署的增值税地址
    address Supervise_address=config_tax_address;
	//supervise地址为广州物价局的监管地址
	
    Tax_interface tax=Tax_interface(Tax_address);
    Token_interface tokenWaste=Token_interface(token_address);
    Supervise_interface supervise=Supervise_interface(Supervise_address);
    
    address public owner; //发布该订单的持有者
    uint256 public order_prize; //订单最终价格
    uint256 public order_end; //订单结束时间
    uint256 public order_start;//订单开始时间
    address public buyer; //订单买家
    bool public ended; //订单结束情况
    uint256 public deadline; //订单结束时间
    string phone_number; //手机号
	string public city;//模糊地址
	string public district;//区
    string public street;//街道 
    string public community;//社区 
	string acc_location;//地址  
    uint order_comfirm_status;  
	//订单的确认状态，订单确认状态有3种，1为开始接单状态，2为接单状态（未取件/配送）
	//3为取件后用户确定，4卖家确定 

    uint256[6] public  waste_list=[0,0,0,0,0,0];
	//订单中废品的情况,单位是克
	uint256[6] public waste_prize_list=[0,0,0,0,0,0];
	
    constructor() public{
        owner = msg.sender;
    }
	
	//订单废品列表，废品价格设置
	function set_order_weight (uint a,uint b,uint c,uint d,uint e,uint f)public {
        require(msg.sender == owner);
        waste_list[0]=a;
        waste_list[1]=b;
        waste_list[2]=c;
        waste_list[3]=d;
        waste_list[4]=e;
        waste_list[5]=f;
    }
    
    function set_order_prize (uint a1,uint b1,uint c1,uint d1,uint e1,uint f1)public{
        require(msg.sender == owner);
        waste_prize_list[0]=a1;
        waste_prize_list[1]=b1;
        waste_prize_list[2]=c1;
        waste_prize_list[3]=d1;
        waste_prize_list[4]=e1;
        waste_prize_list[5]=f1;
    }
	
	
		//总价格计算
	function calculate_order_prize() public returns (uint256) {
		uint256 sum=0;
		for(uint256 i =0;i<6;i++){
			sum=waste_list[i]*waste_prize_list[i]+sum;
		}
		return sum;
    }
	
	//订单开始
    function start_order(string _phone_number,string _city,string _district,string _street,string _community,string _acc_location ) public {
        require(msg.sender == owner);
        order_comfirm_status=1;
        order_start=now;
        order_end = order_start + 60 minutes;
        phone_number=_phone_number;
        city=_city;
        district=_district;
        street=_street;
        community=_community;
        acc_location=_acc_location;
        supervise.Supervise_order();
        //接受监管 
    }
    
    //接单
    function recive_order() public{
        uint256 sub=order_end-now;
        require(sub>=0, "Order already ended.");
		require(order_comfirm_status==1,"order already recived.");
        buyer = msg.sender;
		order_comfirm_status=2;
    }
    
	//公司上门回收,（可能）修改订单
	function order_modify(){
		require(msg.sender==owner);
	}
	
	//用户确定
	function order_comfirm_by_seller() public{
        require(msg.sender==owner,"You're not the seller");
		require(order_comfirm_status==2,"Waiting for bidder");
		order_comfirm_status=3;
		order_prize=calculate_order_prize();
    }

	//买家汇款后，订单结束
	function order_comfirm_by_buyer() payable public{
		require(msg.sender==buyer,"You're not the bidder");
		require(order_comfirm_status==3,"Waiting for seller");
		require(tokenWaste.transferFrom(buyer, address(this),order_prize),"Tranfer fail");
		order_comfirm_status=4;
		ended=true;
	}
	

    //隐藏信息,只有接单的人可以获得隐藏信息，精确地址和手机号码
	function private_message() public returns (string ,string){
		require(msg.sender==buyer);
		return (phone_number, acc_location);
	}
	
    function withdraw_by_owner() public {
	    require(msg.sender==owner,"You're not the owner");
	    require(ended,"order is not ended");
        //扣除税款 
        uint256 tax_account=tax.Calculation_tax(address(this));
        require(tokenWaste.approve(Tax_address,tax_account),"approve error");
        tax.Tax_order();
        order_prize=order_prize-tax_account;
	    require(tokenWaste.transferTo(owner,order_prize));
	}
	
	function revice_spornor(address address_of_sponsor) public returns(uint256) {
	    require(msg.sender==owner);
	    Sponsor_interface sponsor=Sponsor_interface(address_of_sponsor);
	    //接收赞助 
	    uint256 sponsor_fund=sponsor.Sponsor_order(address(this));
	    return sponsor_fund;
	}
	
	function get_owner() view public returns(address){
	    return owner;
	}
	
	function get_buyer() view public returns(address){
	    return buyer;
	}
	
	function get_city() view public returns(string){
	    return city;
	}
	
	function get_district() view public returns(string){
	    return district;
	}

	function get_street() view public returns(string){
	    return street;
	}
	
	function get_community() view public returns(string){
	    return community;
	}
	
	function get_order_comfirm_status() view public returns(uint){
	    return order_comfirm_status;
	}
	
	function get_order_prize() view public returns(uint256){
	    return order_prize;
	}
	
	function get_waste_list(uint a) view public returns(uint){
	    return waste_list[a];
	}
    
    function get_waste_prize_list(uint b) view public returns(uint){
	    return waste_prize_list[b];
	}

	function insert(string order_address,string city,string district,string steet,uint order_status){
	    TableFactory tableFactory;
	    Table table = tableFactory.openTable( "Order_table");
        Entry entry = table.newEntry();
        entry.set("order_address", order_address);
        entry.set("city", city);
        entry.set("district", district);
        entry.set("street", street);
        entry.set("order_status", order_status);
        int256 count = table.insert("order_address", entry);
	}
	
	//
	function insert(string order_address,string class,uint weight,uint prize){
	    TableFactory tableFactory;
	    Table table = tableFactory.openTable( "Waste_table");
        Entry entry = table.newEntry();
        entry.set("order_address", order_address);
        entry.set("class", class);
        entry.set("weight", weight);
        entry.set("prize", prize);
        int256 count = table.insert("order_address", entry);
	}

}
