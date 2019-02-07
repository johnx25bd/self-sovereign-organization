import "./openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./openzeppelin-solidity/contracts/access/Roles.sol";
import "@daostack/infra/contracts/votingMachines/AbsoluteVote.sol";

// gnosis safe - multisig wallet
// reputation ? or role-based reputation (RBR)
//

contract Project is AbsoluteVote {
  using SafeMath for uint;
  using Roles.Role for Role;

  Role participants;

  bool initiated public;
  string githubRepo public;
  string purpose;
  string arbitraryRequirements;
  string legalContractUrl;

  Participant [] participants;
  uint taskId;
  AbsoluteVote absoluteVote;

  mapping(address => uint) owing;
  mapping(uint => Task) tasks;
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

    taskId = taskId.add(1);
    tasks[taskId] = newTask;


    absoluteVote.propose()


    return taskId;
  }

  function voteOnTask(uint _taskId) {
    vote.vote()
    // If failed, _

    // if approved
      // Disburse budget to task owner or TaskWallet contract

  }

  function tally(uint _taskId) public {
    //require(votesAllIn);
    //yes = calculate winner()
    Task memory task = tasks[_taskId];
    if (yes == true) {
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
