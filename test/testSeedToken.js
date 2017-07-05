/**
 * Created by rgavin on 7/4/17.
 */

// Get an instance of the SeedToken contract
var SeedToken = artifacts.require('SeedToken');

contract('SeedToken', function(accounts) {

    it("should have 18 decimal places", function() {
        return SeedToken.deployed().then(function (instance) {
            return instance.decimals.call();
        }).then(function(response) {
            assert.equal(response, 18, "token doesn't have 18 decimal places");

        });
    });

    it("should properly mint new tokens", function() {
        var tokenContract;

        return SeedToken.deployed().then(function(instance) {
            tokenContract = instance;
            return tokenContract.mintToken.sendTransaction(accounts[0], 10000);
        }).then(function(response) {
            assert.ok(response, "call did not return true");
            return tokenContract.balanceOf.call(accounts[0]);
        }).then(function(balance) {
            assert.equal(balance.valueOf(), 10000, "10000 wasn't minted in the first account");
            return tokenContract.totalSupply.call();
        }).then(function(totalSupply) {
            assert.equal(totalSupply.valueOf(), 10000, "10000 wasn't returned as the total supply");
        });
    });

});