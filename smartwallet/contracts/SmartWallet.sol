pragma solidity ^0.6.0;

contract SmartWallet {

    address payable admin;

    event Transfer(uint256 amount);

    constructor () public {
        //set contract deployer as admin
        admin = payable(msg.sender);
    }


    function withdrawAmount(uint256 amount) public {
        require (msg.sender == admin);
        require (amount <= getBalance());
        msg.sender.transfer(amount);
        emit Transfer(amount);
 
     }

     function getBalance() public view returns (uint256) {
         return address(this).balance;
     }

}