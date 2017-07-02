pragma solidity ^0.4.8;

contract Owned {
    modifier onlyOwner { if (msg.sender != owner) return; _; }

    event NewOwner(address indexed old, address indexed current);

    function setOwner(address _new) onlyOwner { NewOwner(owner, _new); owner = _new; }

    address public owner = msg.sender;
}