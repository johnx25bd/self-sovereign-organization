pragma solidity ^0.5.2;

import "./SafeMath.sol";

contract Project {

    using SafeMath for uint;

    bool public initiated;
    string public githubRepo;
    string public purpose;
    string arbitraryRequirements;
    string legalContractUrl;
    uint requiredInvestment;
    uint requiredNumberPaid;
    uint numberPaid;
    uint projectNum;
    uint quorumPct;

    enum TaskStatus { proposed, inProgress, evidenceUnderReview, complete, rejected }

    struct Task {
        TaskStatus status;
        bytes32 taskId;
        address payable owner;
        uint duration; //seconds
        string requirementsGitCommitHash; //git commit hash "36c989247e49df868ff6b990ede7bcfe7c94b5bd"
        uint budget; // wei or dai?
        uint reward;
        uint votePercentage;
        uint taskStart;
        uint submissionTime;
        uint latePenalty; // percent to deduct from reward if late.
        string evidenceGitCommit;
    }

    struct TaskVote {
        uint numVotedProposal;
        uint proposalYesVotes;
        uint numVotedEvidence;
        uint evidenceYesVotes;
    }

    struct Participant {
        address ethAddress;
        string legalName;
        string githubUsername;
        uint investmentValue;
        bool initialized;
        bool paid;
        mapping (bytes32 => bool) taskIdToVoted;
        mapping (bytes32 => uint) taskIdToVotes;
        mapping (bytes32 => bool) evidenceIdToVoted;
        mapping (bytes32 => uint) evidenceIdToVotes;
    }


    mapping(address => uint) owing;
    mapping(bytes32 => Task) public tasks; // bytes32 taskId  to  Task?
    mapping(address => Participant) public participants; // mapping for participants?
    mapping(address => bool) paid;
    mapping(bytes32 => bytes32) public evidenceToTask; // evidenceVoteId => taskId
    mapping(bytes32 => TaskVote) public taskVotes; //taskId to TaskVote
    address[] public participantsArray;

    constructor (
        string memory _githubRepo,
        string memory _adminName,
        string memory _adminGithubUsername,
        string memory _purpose,
        uint _requiredInvestment,
        uint _requiredNumberPaid,
        uint _quorumPct,
        uint _projectNum
    ) public {

        Participant memory admin;
        admin.ethAddress = tx.origin;
        githubRepo = _githubRepo; // test validity
        admin.legalName = _adminName;
        admin.githubUsername = _adminGithubUsername;
        purpose = _purpose;
        admin.initialized = true;
        participants[tx.origin] = admin;
        requiredInvestment = _requiredInvestment;
        requiredNumberPaid = _requiredNumberPaid;
        projectNum = _projectNum;
        quorumPct = _quorumPct;

  }

    function addParticipant(
        address _address,
        string memory _legalName,
        string memory _githubUsername
        ) public {

        require(participants[msg.sender].initialized == true, "DOES_NOT_HAVE_ADMIN_ROLE");

        Participant memory newParticipant;
        newParticipant.ethAddress = _address;
        newParticipant.legalName = _legalName;
        newParticipant.githubUsername = _githubUsername;
        newParticipant.investmentValue = 0;
        newParticipant.initialized = true;
        newParticipant.paid = false;

        participants[_address] = newParticipant;
        participantsArray.push(_address);
    }

    function fund() public payable {
        require(participants[msg.sender].paid == false);

        participants[msg.sender].investmentValue += msg.value;

        if (participants[msg.sender].investmentValue >= requiredInvestment) {
            participants[msg.sender].paid = true;
            numberPaid += 1;
            if (numberPaid >= requiredNumberPaid) {
                initiateProject();
            }
        }

    // convert ether to dai (MakerDAO)
      // ***stuff to code***
      //  swaps for DAI maybe ...
      // Route funds to multisig wallet (Gnosis)
    // paid[msg.sender] = true;
  }

  function initiateProject () internal {
      initiated = true;
      // Here we could add much logic - disbursement of funds, etc.
  }

  function owes(address _participantAddress) public view returns (uint) {
      if (participants[_participantAddress].paid == true) {
          return 0;
      } else {
          return requiredInvestment - participants[_participantAddress].investmentValue;
      }
    //   return requiredInvestment
  }


    event taskProposed (bytes32 taskId_);


    function proposeTask (
        address payable _owner,
        uint _duration, //seconds
        string memory _requirementsGitCommitHash,
        uint _budget,
        uint _reward
    ) public returns (bytes32 ) {

        require(initiated == true);
        require(participants[msg.sender].initialized == true);

        Task memory newTask;
        newTask.owner = _owner;
        newTask.duration = _duration;
        newTask.requirementsGitCommitHash = _requirementsGitCommitHash;
        newTask.budget = _budget;
        newTask.status = TaskStatus.proposed;
        newTask.reward = _reward;

        bytes32 taskId = keccak256(abi.encodePacked(_owner, _requirementsGitCommitHash, now));

        tasks[taskId] = newTask;

        emit taskProposed(taskId);
        return taskId; // necessary? Only ever called by EOA ... maybe ...

  }

  function voteOnTaskProposal (
    bytes32 _taskId,
    uint8 _vote ) public {

    // –––––––––– VOTING ––––––––––
    // Inputs:
    // -- bytes32 taskId = identification hash of the task
    // -- uint8 _vote = the vote


    // Requires
    require(_vote <= 1); // 0 = no, 1 = yes.
    require(participants[msg.sender].paid);



        require(participants[msg.sender].taskIdToVoted[_taskId] == false); // unless we want the option to change votes ... which will require more logic

        Participant storage participant = participants[msg.sender];
        TaskVote storage taskForVote = taskVotes[_taskId];
        Task storage task = tasks[_taskId];

        // Voting
        taskForVote.proposalYesVotes += _vote;
        taskForVote.numVotedProposal += 1;

        participant.taskIdToVoted[_taskId] = true;
        participant.taskIdToVotes[_taskId] = _vote;

        if (taskForVote.numVotedProposal == numberPaid) { // in this implementation,
            bool decision = tallyTaskProposalVotes(taskForVote);

            if (decision == true) {

                address payable taskOwner = task.owner;
                address(taskOwner).transfer(task.budget); // this would be where we instantiate a new taskWallet contract controlled by task owner ...
                task.status = TaskStatus.inProgress;

            } else {
                task.status = TaskStatus.rejected;
            }
        }
    }

function voteOnEvidence(bytes32 _taskId,
    uint8 _vote ) public {

      Participant storage participant = participants[msg.sender];
        Task storage task = tasks[_taskId];
        TaskVote storage taskVote = taskVotes[_taskId];

        // Voting
        taskVote.evidenceYesVotes += _vote;
        taskVote.numVotedEvidence += 1;

        participant.evidenceIdToVoted[_taskId] = true;
        participant.evidenceIdToVotes[_taskId] = _vote;

        if (taskVote.numVotedEvidence == numberPaid) {
            bool decision = tallyTaskEvidenceVotes(taskVote);

            if (decision == true) {

                address payable taskOwner = task.owner;
                if (task.submissionTime > task.submissionTime + task.duration) {
                    address(taskOwner).transfer(task.reward - (task.reward * task.latePenalty / 100)); // this would be where we instantiate a new taskWallet contract controlled by task owner ...
                } else {
                    address(taskOwner).transfer(task.reward);
                }
                task.status = TaskStatus.inProgress;
            } else {
                task.status = TaskStatus.rejected;
            }
        }
    }



  function tallyTaskProposalVotes( TaskVote storage _taskToTally ) internal view returns ( bool ) {

    // Based on quorum percentage set in constructor. Could also implement this for each task, or make
    // quorum proportionate to the budget - higher-value tasks require a greater percentage of project
    // participants to vote to reach consensus:
    if (_taskToTally.proposalYesVotes < (_taskToTally.numVotedProposal * quorumPct / 100)) {
        return false;
    } else {
        return true;
    }
  }

  function submitEvidence ( bytes32 _taskId, string memory _evidenceGitCommitHash ) public {

        require(tasks[_taskId].owner == msg.sender);

        Task storage taskReceivingEvidence = tasks[_taskId];

        taskReceivingEvidence.evidenceGitCommit = _evidenceGitCommitHash;
        taskReceivingEvidence.submissionTime = now;
        taskReceivingEvidence.status = TaskStatus.evidenceUnderReview;
  }

  function voteOnEvidence ( bytes32 _taskId, uint _evidenceVote ) public {
        require(participants[msg.sender].initialized == true);



  }

  function tallyTaskEvidenceVotes( TaskVote storage _taskEvidenceToTally ) internal view returns ( bool ) {

    // Based on quorum percentage set in constructor. Could also implement this for each task, or make
    // quorum proportionate to the budget - higher-value tasks require a greater percentage of project
    // participants to vote to reach consensus:
    if (_taskEvidenceToTally.evidenceYesVotes < (_taskEvidenceToTally.numVotedEvidence * quorumPct / 100)) {
        return false;
    } else {
        return true;
    }
  }

  event participantsLength(uint);

  function getParticipantsLength () public returns (  uint ) {

        uint numParticipants = participantsArray.length;

        emit participantsLength(numParticipants);
        return numParticipants;
        // string[] memory ps = ["yes", "no", "why not"];
    //   return ( address(this), githubRepo, ps, 1);


  }


}
