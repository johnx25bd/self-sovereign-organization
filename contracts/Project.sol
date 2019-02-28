import "installed_contracts/zeppelin/contracts/math/SafeMath.sol";
import "installed_contracts/zeppelin/contracts/access/Roles.sol";
import "node_modules/@daostack/infra/contracts/votingMachines/AbsoluteVote.sol";
import "./IntVoteInterface.sol";

// gnosis safe - multisig wallet
// reputation ? or role-based reputation (RBR)
//

contract ProjectFactory {
  using SafeMath for uint;

  uint projectNum;

  constructor () {

  }

  function createProject () {

    projectNum = projectNum + 1;
  }


}

contract Project is AbsoluteVote {
  using SafeMath for uint;
  using Roles.Role for Role;

  // Setting up the interface to use absoluteVote
  IntVoteInterface absoluteVote;
  bytes32 voteParametersHash;

  Role participants;
  bool initiated public;
  string githubRepo public;
  string purpose public;
  string arbitraryRequirements;
  string legalContractUrl;

  Participant [] participants;
  uint taskCnt;
  // AbsoluteVote absoluteVote;

  mapping(address => uint) owing;
  mapping(uint => Task) tasks; // bytes32 taskId  to  Task?
  mapping(address => Participant) participants; // mapping for participants?
  mapping(address => bool) paid;
  mapping(bytes32 => uint) quorums;
  mapping(bytes32 => bytes32) evidenceToTask; // evidenceVoteId => taskId

  enum TaskStatus = {proposed, inProgress, rejected};

  struct Task {
    // or should this be a contract?!?!??!
    TaskStatus status;
    bytes32 taskId;
    address owner,
    uint duration, //seconds
    string requirementsGitCommit, //git commit hash "36c989247e49df868ff6b990ede7bcfe7c94b5bd"
    uint budget, // wei or dai?
    uint reward,
    uint votePercentage,
  }

  struct Participant {
    address ethAddress;
    string legalName;
    string githubUsername;
    uint owes
    float equity;
    string name;
    // DID ?
  }

  constructor(string _githubRepo, address _adminRole, string _purpose, address _voteInterface, uint _votePercentage) public {
    participants.add(_adminRole);

    // address IntVoteInterfaceAddress = 0x8405f70a82d2719057892e7d19e2db35f23cae5b; // address of the absoluteVote contract on Ganache
    absoluteVote = IntVoteInterface(_voteInterface);
    absoluteVote.setParameters(_votePercentage, true);

    githubRepo = _githubRepo; // test validity
    purpose = _purpose;
    // create participants[] array with addresses
  }

  // Invoked daily by server-side CRON .
  function statusCheck () {
    // check vote status
  }

  function addParticipant(address _address) public {
    require(participants.has(msg.sender), "DOES_NOT_HAVE_ADMIN_ROLE");
    participants.add(_address);
    owing[_address] =
  }

  function fund() public payable {
    require(owing[msg.sender]);
    require(paid[msg.sender] == false);
    require(msg.value >= owing[msg.value]);
    // convert ether to dai (MakerDAO)
      // ***stuff to code***
      //  swaps for DAI maybe ...
      // Route funds to multisig wallet (Gnosis)
    paid[msg.sender] = true;
  }

  function initiate(_legalContractUrl) public  {
    for (uint i = 0; i < participants.length; i++) {
      require(paid[participants[i]]);
    }
    legalContractUrl = _legalContractUrl;
    // do something with dai?
    initiated = true;
  }

  function proposeTask
  (
    address _owner,
    uint _duration, //seconds
    string _requirementsGitCommit, //git commit hash "36c989247e49df868ff6b990ede7bcfe7c94b5bd"
    uint _budget, // wei or dai?
    uint _reward,
    uint _votePercentage,
  ) public
    returns (bytes32){

    require(initiated == true);
    require(participants[msg.sender] != 0);
    // create Task

    Task memory newTask;
    newTask.owner = _owner;
    newTask.duration = _duration;
    newTask.requirements = _requirementsGitCommit;
    newTask.budget = _budget;
    newTask.status = TaskStatus.proposed;
    newTask.reward = _reward;


    // Voting parameters and schemes params:
      // _votePercentage defined by proportion of funds proposed to be spent or something
      uint votePercentage = _votePercentage;
    voteParametersHash = absoluteVote.getParametersHash(
      votePercentage,
      true
    );

    // Hash this?
    taskCnt = taskCnt.add(1);
    tasks[taskCnt] = newTask;

    // –––––––––– PROPOSING ––––––––––
    // We should use interfaces – these allow us to call functions from other contracts

    // next, calling PROPOSE
    // Need to pass: 1) # of choices  2) paramsHash  3) msg.sender  4) organisation address
    // -- numOfChoices = 2 ('yes' or 'no')
    // -- paramsHash = absoluteVote.getParamsHash() AFTER setting the parameters by calling absoluteVote.setParams()
    // -- msg.sender
    // -- address _organization = if 0, _organization = msg.sender

    // However, it seems that absoluteVote also stores different proposals (tasks)
    // Hence, if used as it is, we would store all the info twice

    // Build out initiating task voting period
    uint numOfChoices = 1;


    bytes32 taskId = absoluteVote.propose(numOfChoices, voteParametersHash, msg.sender, address(this));
    quorums[taskId] = votePercentage;

    // Figure how to to transmit taskId to client for proposer to email to other participants
    // With an event.
    return taskId;
    // ideally we have a db on the server with tasks and statuses, including everyone who has and hasn't voted on them.
    // When people log in, they get an interface with Things They Need To Vote On and Tasks They Need To Complete

    // BUT for MVP - proposer emails the other members the taskId and asks them to go vote
  }

  // Called by task owner
  function submitEvidence (uint _taskId, string _evidenceGitCommit) public returns (bytes32) {
    Task memory task = tasks[_taskId];

    require(task.owner == msg.sender); // do we need this?
    require(task.TaskStatus == TaskStatus.inProgress);
    task.submissionTime = now; /// this will be messed if multiple submissions of evidence are called
    task.evidenceGitCommit = _evidenceGitCommit;

    tasks[_taskId] = task;

    // Again, transmit evidenceVoteId to client with event.
    bytes32 evidenceVoteId = initiateEvidenceBallot();
    evidenceToTask[evidenceVoteId] = _taskId;

    return evidenceVoteId;
    // pretty much always invoke initiateEvidenceBallot() immediately ...
  }

  function initiateEvidenceBallot () private returns (bytes32) {
    uint numOfChoices = 1;
    bytes32 evidenceVoteId = absoluteVote.propose(numOfChoices, voteParametersHash, msg.sender, address(this));
    return evidenceVoteId;
  }


  /*
  @params _ballotId bytes32 returned by absoluteVote.propose() - i.e. ballot reference
  @params _vote uint 0 = NO, 1 = YES.
  */
  function voteOnProposedTask(bytes32 _ballotId, uint _vote) {

    // –––––––––– VOTING ––––––––––
    // Inputs:
    // -- bytes32 taskId = identification hash of the task
    // -- uint256 _vote = the vote
    // -- uint256 _amount = reputation
    // -- address _voter = this is used if you are allowed to vote on someone's behalf

    // Accessing data
    Task memory task = tasks[_taskId];
    Participant memory participant = participants[msg.sender];

    // Initialising inputs
    vote = _vote;
    reputation = participant.equity; // is reputation = equity? ... or hard code this so everyone is equal this iteration
    voter = msg.sender; // no delegation - for now
    bool voteDecision; // what does bool represent? AbsoluteVote ... vote() ... internalVote() ... _execute()

    // Voting
    voteDecision = absoluteVote.vote(_taskId, vote, reputation, voter);
    if (/* approved */) {
      // get info from tasks][_taskId]
      // transmit budget to owner address
        // change task status to inProgress
      } else if (/* failed */) {
        // change taskStatus to rejected
        // here we could unlock budget that could be locked upon task proposal ...
        // need to make sure budget exists for any proposed tasks ...
      } else {
        // ????
      }


    task.totalVotes = task.totalVotes.add(1); // add to the total number of votes
      // ^^ this logic is likely handled, again, by AbsoluteVote

    // if not completed (or threshold has been passed), returns False
    // if completed, emits ExecuteProposal from IntVoteInterface
      // AND returns executeProposal function inside ProposalExecuteInterface
      // I am guessing we could replace this to return True


    // If failed, _
    // if approved
      // Disburse budget to task owner or TaskWallet contract

    // if everyone voted
    uint quorum = quorums[_taskId];

    if (task.totalVotes >= quorum) {
      // pretty sure this is native to AbsoluteVote contracts ...
      tally(_taskId, voteDecision);
    }


  }

  function voteOnEvidence(bytes32 _evidenceVoteId, uint _vote) {

    // –––––––––– VOTING ––––––––––
    // Inputs:
    // -- bytes32 taskId = identification hash of the task
    // -- uint256 _vote = the vote
    // -- uint256 _amount = reputation
    // -- address _voter = this is used if you are allowed to vote on someone's behalf

    // Accessing data
    bytes32 memory taskId = evidenceToTask[_evidenceVoteId];
    Task memory task = tasks[taskId];
    Participant memory participant = participants[msg.sender];

    // Initialising inputs
    vote = _vote;
    reputation = participant.equity; // is reputation = equity? ... or hard code this so everyone is equal this iteration
    voter = msg.sender; // no delegation - for now
    bool voteDecision; // what does bool represent? AbsoluteVote ... vote() ... internalVote() ... _execute()

    // Voting
    voteDecision = absoluteVote.vote(_taskId, vote, reputation, voter);
    if (/* approved */) {
      // if (now < deadline)
        // transmit reward to owner address
      // change task status to completed
    } else if (/* failed */) {
        // do not change taskStatus
        // Can owners resubmit, or do we have a failed state in TaskStatus enum?
    } else {
        // ????
    }

    // --------- this needs work vvvv ---------
    // if not completed (or threshold has been passed), returns False
    // if completed, emits ExecuteProposal from IntVoteInterface
      // AND returns executeProposal function inside ProposalExecuteInterface
      // I am guessing we could replace this to return True

    // if everyone voted
    uint quorum = quorums[_taskId];

    if (task.totalVotes >= quorum) {
      // pretty sure this is native to AbsoluteVote contracts ...
      tally(_taskId, voteDecision);
    }


  }

// do we need this?
  function tally(uint _taskId, bool _voteDecision) public {
    require(_voteDecision);

    Task memory task = tasks[_taskId];
    if (_voteDecision == true) {
      task.status = TaskStatus.inProgress;
      task.deadline = now + task.duration;
      (task.owner).transfer(task.budget); // or transfer to task budget wallet, owned by owner or multisig ...
    }
    else {
      task.status = TaskStatus.rejected;
    }
  }


  // do we need this?
  // Called by admin or voteOnEvidence()
  function tallyEvidenceVotes (_evidenceVoteId) {

    require( /* all votes are in */ );

    if (rejected) {
      task.taskStatus = TaskStatus.inProgress;
      // extend deadlines
    } else {
      task.taskStatus = TaskStatus.completed;
      // pay out reward
      // whatever else
    }
  }


  function destroyProject () {

    // Some voting mechanism - probably supermajority or unanimous
    // Revoke funds from task budget wallets
    // Redistribute funds to participants or investors proportionate to - investment. reputation. number of tasks completed. whatever.
    initiated = false;
  }

  function upgradeProject () {
    // migrate to new contract logic  ........ NOT MVP.
  }
}
