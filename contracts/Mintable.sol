pragma solidity ^0.4.8;

contract Mintable {
    event TokenMinted(address _receiver, uint256 _amount);
    function mintToken(address _receiver, uint256 _amount) returns (bool);
}
