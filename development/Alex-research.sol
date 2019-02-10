
Peep analysis:

1. Proposal is an event:

event NewPeepProposal(
    address indexed _avatar,
    bytes32 indexed _proposalId,
    address indexed _intVoteInterface,
    address _proposer,
    string _peepHash,
    uint _reputationChange
);

event ProposalExecuted(address indexed _avatar, bytes32 indexed _proposalId, int _param);


2. 
