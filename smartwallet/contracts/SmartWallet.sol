pragma solidity ^0.8.0;

//import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/access/Ownable.sol";
import "./lib/GenesisUtils.sol";
import "./interfaces/ICircuitValidator.sol";
import "./verifiers/ZKPVerifier.sol";

contract SmartWallet is ZKPVerifier {

    address successor;
    address old_admin;
    address admin;
    uint64 public constant TRANSFER_REQUEST_ID = 1;
    uint64 public vote_state = 0;
    uint64 public vote_threshold;


    mapping(uint256 => address) public idToAddress;
    mapping(address => uint256) public addressToId;
    mapping(uint256 => bool) public idToVote;

    event Transfer(uint256 amount);
    event Received(address sender, uint256 amount);
    event VoteReceived(uint256 id);
    event AdminChanged(address old_admin, address new_admin);

    constructor (address _successor, uint64 _vote_threshold) {
        //set successor as next in line for ownership
        successor = _successor;
        vote_threshold = _vote_threshold;
        admin = msg.sender;
    }

    function _beforeProofSubmit(
        uint64, /* requestId */
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal view override {
        // check that the challenge input of the proof is equal to the msg.sender 
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
        
        uint256 id = inputs[validator.getChallengeInputIndex()];
        //count vote
        _countVote(id);
    }

    function withdrawAmount(uint256 amount) public {
        require (msg.sender == admin);
        require (amount <= getBalance());
        
        payable(admin).transfer(amount);
        emit Transfer(amount);
 
    }

    function _countVote(uint256 id) private {
        
        // check if this id has voted
        if (idToVote[id] == false){
            vote_state += 1;
            idToVote[id] = true;
            emit VoteReceived(id);
        }

        // check if votes have reach threshold
        if (vote_state == vote_threshold){
            //transfer ownership
            old_admin = admin;
            //Transfer ownership
            admin = successor;
            emit AdminChanged(old_admin, admin);
        }
        
        emit VoteReceived(id);
    } 

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

}