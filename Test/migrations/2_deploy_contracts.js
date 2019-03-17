const SealedAuction = artifacts.require("./SealedAuction.sol");

module.exports = function(deployer) {
  deployer.deploy(SealedAuction);
};
