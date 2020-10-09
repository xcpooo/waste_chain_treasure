import "./Token_interface.sol";
import "./Order_interface.sol";
import "./Sponsor_interface.sol";
import "./config.sol";
pragma solidity ^0.4.25;
/*
赞数商合约，在订单合约交易中，调用赞助商合约，订单交易完成后，卖家会收到来自赞助商的赞助
*/

contract guangzhou_university_sponsor is Sponsor_interface,config {
    address token_address=config.credit_token_address;
    //地址填写学分token的地址
    uint256  balance;
    mapping(address => uint256) public donationOf;
    address public owner;
    uint256 public sponsor_account;
    Token_interface tokenwaste=Token_interface(token_address);
    
    constructor (){
        owner=msg.sender;
        sponsor_account=20;
	//赞助20学分token
        balance=0;
    }
    
    function Sponsor_order(address order_address) payable public returns(uint256 _sponsor_account){
       Order_interface order=Order_interface(order_address);
       if (keccak256(order.get_city())==keccak256("guangzhou")){
	       bool sucess=tokenwaste.transferTo(order.get_owner(),sponsor_account);
	   }
	   return sponsor_account;
    }
    
    function donation(uint256 _account) public returns(bool sucess_status){
        //政府或者环保组织布置的合约可以接受其他人的捐款
        tokenwaste.transferFrom(msg.sender, address(this),_account);
        donationOf[msg.sender]=_account;
        balance=balance+_account;
        return true;
    }

    
    
}
