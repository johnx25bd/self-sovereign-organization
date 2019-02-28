const Project = artifacts.require("Project");

module.exports = function(deployer, network, accounts) {
  const secondary = accounts[1];
  const tertiary = accounts[2];

  deployer.deploy(VaccineRegistration, secondary, tertiary);
};
