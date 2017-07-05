pragma solidity ^0.4.8;

import "./ERC20.sol";
import "./Mintable.sol";
import "./TokenRecipient.sol";
import "./Owned.sol";

contract SeedToken is Owned, Mintable, ERC20 {
    /* Public variables of the token */
    string public standard = 'Token 0.1';
    string public name = "Seed Token";
    string public symbol = "SEED";
    uint8 public decimals = 18;
    uint256 supply = 0;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    /* This notifies clients about the amount burnt */
    event Burn(address indexed from, uint256 value);

    function totalSupply() constant returns (uint256 totalSupply) {
        return supply;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balanceOf[_owner];
    }

    /* Mint coins */
    function mintToken(address _receiver, uint256 _amount) onlyOwner returns (bool success) {
        if (_receiver == 0x0) return false;                         // Prevent transfer to 0x0 address
        supply += _amount;                                          // Add to the total supply
        balanceOf[_receiver] += _amount;                            // Add to the receiver's balance
        TokenMinted(_receiver, _amount);                            // Notify anyone listening that new tokens have been minted
        return true;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (_to == 0x0) return false;                               // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[msg.sender] < _value) return false;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) return false; // Check for overflows
        balanceOf[msg.sender] -= _value;                            // Subtract from the sender
        balanceOf[_to] += _value;                                   // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                          // Notify anyone listening that this transfer took place
        return true;
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /* Approve and then communicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        TokenRecipient spender = TokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            Approval(msg.sender, _spender, _value);
            return true;
        }
    }

    /* Returns the allowance approved by the owner for the spender */
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowance[_owner][_spender];
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (_to == 0x0) return false;                               // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[_from] < _value) return false;                // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) return false; // Check for overflows
        if (_value > allowance[_from][msg.sender]) return false;    // Check allowance
        balanceOf[_from] -= _value;                                 // Subtract from the sender
        balanceOf[_to] += _value;                                   // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;                     // Subtract the allowance
        Transfer(_from, _to, _value);
        return true;
    }

    function burn(uint256 _value) returns (bool success) {
        if (balanceOf[msg.sender] < _value) return false;           // Check if the sender has enough
        balanceOf[msg.sender] -= _value;                            // Subtract from the sender
        supply -= _value;                                           // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) returns (bool success) {
        if (balanceOf[_from] < _value) throw;                       // Check if the sender has enough
        if (_value > allowance[_from][msg.sender]) throw;           // Check allowance
        balanceOf[_from] -= _value;                                 // Subtract from the sender
        supply -= _value;                                           // Updates totalSupply
        Burn(_from, _value);
        return true;
    }
}