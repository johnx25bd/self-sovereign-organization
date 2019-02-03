pragma solidity ^0.5.2;

import '@daostack/arc/contracts/universalSchemes/UniversalScheme.sol';





// Data
enum statuses {x, y, z}; // potential statuses for tasks -
mapping (address => participant) participants;
mapping (address => investor) investors;

struct participant {
  address ethaddress;
  string githubusername;
  float equity;
  // DID ?
}

struct Investor {
  address ethaddress;
  uint amtinvested;
}

struct IpfsHash {
  bytes32 hash;
  uint hashSize;
}

enum TaskStatus {proposed, rejected, inProgress, evidenceSubmitted, completed};

struct Task {
  uint id;
  address owner;

  IpfsHash requirementsIpfsHash; // ipfs address to file detailing requirements or git commit message
  string requirementsGitCommit; // URL to github file
  IpfsHash evidence; // address to file (encrypted?)
  GitCommit evidenceGitCommit;
  bool approved;
  TaskStatus taskStatus;
  uint budget; // wei
  uint reward;
  address budgetrecipient; // more sophisticated - address and proportion / absolute number of budget?
  mapping[] dependencies; // tasks that must be complete prior to this task
  address[] reviewers; // reviewers who need to approve task - may need more nuance - weighted votes, say
  uint deadline;
  uint duration;
  uint submissionTime;
  // more here about arbitrator address maybe?
}

// Some structure superior to Task - Sprint or Milestone?

// contract addresses for payment wallets - automatically disburse

constructor () public {
  // constructor function
  // perhaps define list of approved investors
}

function deploy () {
  // multisig / funding requirement to deploy project

}

function invest () payable {
  amount += msg.value;
  // update
}

function disburse () {
  // disburse funds to appropriate address
}

function submit () {
  // accepts info about participant, evidence
  // Checks if compliant with task requirements
  // Updates task, triggers review process?
}

function review (address reviewer, bool approved, string reasoning) {
  // for each reviewer to submit
  // string reasoning is chance to provide feedback / reason, esp for rejection
}

function undeploy () {
  // multisig (?) project termination function
  // returns remaining funds proportionately to participants / investors per pre-set terms

}
