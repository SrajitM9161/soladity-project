//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract Will {
    address owner = msg.sender;
    uint fortune= msg.value;
    bool deceased= false;


    // create modifier so the only person who can call the contract is the owner
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // only allocate funds if friend's gramps is deceased

    modifier mustBeDeceased {
        require(deceased == true);
        _;
    }    

    // list of family wallets
    address payable[] familyWallets;

    // map through inheritance
    mapping(address => uint) inheritance;
    function setInheritance( address payable wallet, uint amount)  public{
       familyWallets.push(wallet);
        inheritance [wallet]= amount;
    }

    // set inheritance for each address 
    function payout() private mustBeDeceased {
        for(uint i=0; i<familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
            // transferring funds from contract address to reciever address
        }
    }

    // oracle switch
    function hasDeceased() public onlyOwner {
        deceased = true;
        payout();
    }
}