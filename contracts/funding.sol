//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract funding {
    mapping (address =>uint)public Funder;
    address public company ;
    uint public minimum_funding;
    uint public target;
    uint  public deadline;
   uint public amountdeposit;
   uint public numfunders;

    struct vote{
        string needofmoney;
        address payable resipient ;
        uint amountneed;
        bool agree;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }
   mapping(uint=>vote) public requests;
    uint public numRequests;

   
     constructor(uint _target,uint _Deadline){
        target=_target;
        deadline=block.timestamp+_Deadline; //10sec + 3600sec (60*60)
        minimum_funding=1000 wei;
        company=msg.sender;
    }
    
    function sendEth() public payable{
        require(block.timestamp < deadline,"Deadline has passed");
        require(msg.value >=minimum_funding,"Minimum Contribution is not met");
        
        if(Funder[msg.sender]==0){
            numfunders++;
        }
        Funder[msg.sender]+=msg.value;
        amountdeposit+=msg.value;
    }
    function getamount() public view returns(uint){
        return address(this).balance;
    }
    function refund () public{
        require(block.timestamp>deadline && amountdeposit>target, "YOU ARE NOT ELIDGIBLE FOR REFUND ");
        require(Funder[msg.sender] >0); 
        address payable user= payable(msg.sender);
        user.transfer(Funder[msg.sender]);
        Funder[msg.sender]==0;


    }
modifier forcompany(){
    require(msg.sender==company,"ONLY FOR COMPANY");
    _;
}

}