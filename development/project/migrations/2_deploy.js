const Project = artifacts.require("Project");
// const ProjectFactory = artifacts.require("ProjectFactory");

module.exports = function(deployer, network, accounts) {


  // await absoluteVote.setParameters(100, true);
  //
  // var voteParametersHash = await absoluteVote.getParametersHash(100, true);

  // deployer.deploy(ProjectFactory);
  deployer.deploy(Project, 'self-sovereign-org', accounts[3], 'string', 'string', 'string', accounts[4], 100, 100);
};
