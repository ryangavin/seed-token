var SeedToken = artifacts.require("./SeedToken.sol");

module.exports = function(deployer) {
    deployer.deploy(SeedToken);
};