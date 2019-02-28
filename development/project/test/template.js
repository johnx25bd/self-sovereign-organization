const {
  BN,
  expectEvent,
  shouldFail,
  constants,
  balance,
  send,
  ether
} = require("openzeppelin-test-helpers");
web3.utils.utf8ToHex");
const padRight = web3.utils;

const Project = artifacts.require("Project");

contract('Project', function () {
  let project;
  beforeEach(async function () {
    project = await Project.new();
  });
  describe("init", function () {
    it("should set state", async function () {
      setup();
      (await project.init());
      (await project.myStateVariable()).should.be.bignumber.equal(new BN(1));
    });

  });
});
