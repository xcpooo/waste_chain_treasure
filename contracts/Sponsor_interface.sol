interface Sponsor_interface {
    //赞助订单
    function Sponsor_order(address order_address) payable public returns(uint256 _sponsor_account);
    
    //政府或者环保组织布置的合约可以接受其他人的捐款
    function donation(uint256 _account) public returns(bool sucess_status);

}
