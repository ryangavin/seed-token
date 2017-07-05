pragma solidity ^0.4.8;

contract Owned {

    address public owner = msg.sender;

    event NewOwner(address indexed old, address indexed current);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function setOwner(address _new) onlyOwner {
        NewOwner(owner, _new);
        owner = _new;
    }
}