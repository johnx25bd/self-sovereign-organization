import "./openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./openzeppelin-solidity/contracts/access/Roles.sol";
import "@daostack/infra/contracts/votingMachines/AbsoluteVote.sol";
import "./IntVoteInterface.sol";

// gnosis safe - multisig wallet
// reputation ? or role-based reputation (RBR)
//

contract Project is AbsoluteVote {
  using SafeMath for uint;
  using Roles.Role for Role;

  // Setting up the interface to use absoluteVote
  address IntVoteInterfaceAddress = 0x8405f70a82d2719057892e7d19e2db35f23cae5b; // address of the absoluteVote contract on Ganache
  IntVoteInterface absoluteVote = IntVoteInterface(IntVoteInterfaceAddress);

  Role participants;
  bool initiated public;
  string githubRepo public;
  string purpose;
  string arbitraryRequirements;
  string legalContractUrl;

  Participant [] participants;
  uint taskId;
  // AbsoluteVote absoluteVote;

  mapping(address => uint) owing;
  mapping(uint => Task) tasks; // bytes32 taskId  to  Task?
  mapping(address => Participant); // mapping for participants?
  mapping(address => bool) paid;

  struct Participant {
    address ethAddress;
    string githubUsername;
    uint owes
    float equity;
    string name;
    // DID ?
  }

  constructor(string _githubRepo, address _adminRole, string _purpose) public {
    participants.add(_adminRole);
    absoluteVote = new AbsoluteVote();
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
  }

  function fund() public payable {
    require(owing[msg.sender]);
    require(paid[msg.sender] == false);
    require(msg.value >= owing[msg.value]);
    // forward money to gnosis safe
      // ***stuff to code***

    paid[msg.sender] = true;
  }

  function initiate(_legalContractUrl) public  {
    for (uint i = 0; i < participants.length; i++) {
      require(paid[participants[i]]);
    }
    legalContractUrl = _legalContractUrl;
    initiated = true;
  }

  function proposeTask
  (
    address _owner,
    uint _duration, //seconds
    string _requirementsGitCommit, //git commit hash "36c989247e49df868ff6b990ede7bcfe7c94b5bd"
    uint _budget, // wei
    uint _reward
  ) public
    returns (uint){

    require(initiated == true);
    // create Task
    Task memory newTask;
    newTask.owner = _owner;
    newTask.duration = _duration;
    newTask.requirements = _requirementsGitCommit;
    newTask.budget = _budget;
    newTask.status = TaskStatus.proposed;
    newTask.reward = _reward;

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

    bytes32 taskId;
    taskId = absoluteVote.propose(numOfChoices, paramsHash, msg.sender, organisationAddress);

    return taskId;
  }

  function voteOnTask(uint _taskId, uint _vote) {

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
    reputation = participant.equity; // is reputation = equity?
    voter = msg.sender;
    bool voteDecision;

    // Voting
    voteDecision = absoluteVote.vote(_taskId, vote, reputation, voter);
    task.totalVotes = task.totalVotes.add(1); // add to the total number of votes

    // if not completed (or threshold has been passed), returns False
    // if completed, emits ExecuteProposal from IntVoteInterface
      // AND returns executeProposal function inside ProposalExecuteInterface
      // I am guessing we could replace this to return True


    // If failed, _
    // if approved
      // Disburse budget to task owner or TaskWallet contract

    // if everyone voted
    if task.totalVotes == len(participants) {
      tally(_taskId, voteDecision);
    } else {
      _;
    }


  }

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

  // Called by task owner
  function submitEvidence (uint _taskId, string _evidenceGitCommit) {
    Task memory task = tasks[_taskId];

    require(task.owner == msg.sender); // do we need this?
    require(task.TaskStatus == TaskStatus.inProgress);
    task.submissionTime = now; /// this will be messed if multiple submissions of evidence are called
    task.evidenceGitCommit = _evidenceGitCommit;

    tasks[_taskId] = task;
  }

  // Called by each participant or voter.
  function voteOnEvidence () {
    // Once we figure out voting mechanism, implement here.
    // This would leverage task.reviewers[] .... but not yet.


    // if votes.length = participants.length {
      // tallyEvidenceVotes()
    //}

  }

  // Called by admin or voteOnEvidence()
  function tallyEvidenceVotes () {

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
