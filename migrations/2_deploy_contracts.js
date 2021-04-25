var RSVP = artifacts.require("./RSVP.sol");

module.exports = function(deployer) {
  deployer.deploy(RSVP);
};
