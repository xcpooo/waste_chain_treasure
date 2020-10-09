import "./Tax_interface.sol";
import "./Token_interface.sol";
import "./Order_interface.sol";
import "./config.sol";
import "./Table.sol";
pragma solidity ^0.4.25;
/*
赞数商合约，在订单合约交易中，调用赞助商合约，订单交易完成后，卖家会收到来自赞助商的赞助
*/

contract Guangzhou_tax is Tax_interface,config{
    address token_address=config_token_address;
    Token_interface token=Token_interface(token_address);
    uint256  balance;//已征收的税额
    address public owner;//税务局的账号
    string public Tax_law="value added tax"; 

    
    constructor (){
        owner=msg.sender;
        balance=0;
    }
    
    function Tax_order() public {
        Order_interface order=Order_interface(msg.sender);
        uint256 Tax_account=Calculation_tax(msg.sender);
        require(token.transferFrom(msg.sender,address(this),Tax_account),"Fail to pay tax");
        insert(msg.sender,Tax_account,Tax_law);
        balance=balance+Tax_account;
    }
    
    function Calculation_tax(address Order_address) public view returns(uint256){
        Order_interface order=Order_interface(Order_address);
        uint256 tax_account=0;
        tax_account=order.get_order_prize()/100;
        return tax_account;
    }
    
    function withdraw() public {
        require(msg.sender==owner);
        
    }
    
    function insert(address order_address,uint256 tax_account,string tax_law){
	    TableFactory tableFactory;
	    Table table = tableFactory.openTable( "Tax_table");
        Entry entry = table.newEntry();
        entry.set("order_address", order_address);
        entry.set("tax_account", tax_account);
        entry.set("tax_law", tax_law);
        int256 count = table.insert("order_address", entry);
	}

}
