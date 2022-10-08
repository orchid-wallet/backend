pragma solidity ^0.8.0;

import "./lib/GenesisUtils.sol";
import "./interfaces/ICircuitValidator.sol";
import "./verifiers/ZKPVerifier.sol";

contract SmartWallet is ZKPVerifier {

    address payable admin;
    address successor;
    uint64 public constant TRANSFER_REQUEST_ID = 1;
    uint64 public vote_state = 0;


    mapping(uint256 => address) public idToAddress;
    mapping(address => uint256) public addressToId;

    event Transfer(uint256 amount);
    event Received(address sender, uint256 amount);

    constructor (address _successor) public {
        //set contract deployer as admin
        successor = _successor;
        admin = payable(msg.sender);
    }

    function _beforeProofSubmit(
        uint64, /* requestId */
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal view override {
        // check that the challenge input of the proof is equal to the msg.sender 
        // TODO I don't think we need this logic, delete later
        address addr = GenesisUtils.int256ToAddress(
            inputs[validator.getChallengeInputIndex()]
        );
        require(
            _msgSender() == addr,
            "address in the proof is not a sender address"
        );
    }

    function _afterProofSubmit(
        uint64 requestId,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal override {
        require(
            requestId == TRANSFER_REQUEST_ID && addressToId[_msgSender()] == 0,
            "proof can not be submitted more than once"
        );
        //change state
        vote_state = 1;
    }

    function withdrawAmount(uint256 amount) public onlyOwner {
        require (amount <= getBalance());
        admin.transfer(amount);
        emit Transfer(amount);
 
    }

     function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

}