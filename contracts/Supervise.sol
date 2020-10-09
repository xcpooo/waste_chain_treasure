import "./Tax_interface.sol";
import "./Token_interface.sol";
import "./Order_interface.sol";
import "./Supervise_interface.sol";
import "./config.sol";
import "./Table.sol";
pragma solidity ^0.4.25;
/*
赞数商合约，在订单合约交易中，调用赞助商合约，订单交易完成后，卖家会收到来自赞助商的赞助
*/

contract Supervise is Supervise_interface,config{
    address public owner;//广州物价局的账号
    string supervise_reason="Abnormal price";
    uint256 [6] average_prize=[1,1,1,1,1];

    mapping (address=>uint) public order_status  ;
    constructor (){
        owner=msg.sender;
    }
    
    function Supervise_order() public {
        Order_interface order=Order_interface(msg.sender);
        for (uint i =0;i<6;i++){
            if (order.get_waste_prize_list(i)>average_prize[i]+average_prize[i]/2){
                insert(msg.sender,order.get_owner(),supervise_reason);
            }
        }
    }
    
    function insert(address order_address,address seller,string supervise_reason){
	    TableFactory tableFactory;
	    Table table = tableFactory.openTable( "Supervise_table");
        Entry entry = table.newEntry();
        entry.set("order_address", order_address);
        entry.set("seller", seller);
        entry.set("reason", supervise_reason);
        int256 count = table.insert("order_address", entry);
	}
    
}
