/**
 * Tests the various functions of the SeedToken
 *
 * TODO make tests more independent
 *
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

    it("should properly transfer tokens", function () {
        var tokenContract;

        return SeedToken.deployed().then(function(instance) {
            tokenContract = instance;
            return tokenContract.transfer.sendTransaction(accounts[1], 5000);
        }).then(function (response) {
            assert.ok(response, "call did not return true");
            return tokenContract.balanceOf.call(accounts[0]);
        }).then(function (response) {
            assert.equal(response.valueOf(), 5000, "sender did not have amount deducted from balance");
            return tokenContract.balanceOf.call(accounts[1]);
        }).then(function (response) {
            assert.equal(response.valueOf(), 5000, "receiving balance was not incremented");
        })
    });

    it("should properly approve tokens for transfer", function () {
        var tokenContract;

        return SeedToken.deployed().then(function (instance) {
            tokenContract = instance;
            return tokenContract.approve.sendTransaction(accounts[1], 5000);
        }).then(function (response) {
            assert.ok(response);
            return tokenContract.allowance.call(accounts[0], accounts[1]);
        }).then(function (response) {
            assert.equal(response.valueOf(), 5000, "allowance was not updated");
        });
    });

    it("should properly transfer approved tokens", function () {
        var tokenContract;

        return SeedToken.deployed().then(function (instance) {
            tokenContract = instance;
            return tokenContract.transferFrom.sendTransaction(accounts[0], accounts[1], 5000, {'from': accounts[1]});
        }).then(function (response) {
            assert.ok(response);
            return tokenContract.balanceOf.call(accounts[1]);
        }).then(function (response) {
            assert.equal(response.valueOf(), 10000, "balance was not updated");
            return tokenContract.allowance.call(accounts[0], accounts[1]);
        }).then(function (response) {
            assert.equal(response.valueOf(), 0, "allowance was not updated");
        });
    });

});