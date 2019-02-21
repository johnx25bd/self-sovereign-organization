# Front-end interfaces

Responsive interfaces allowing participants to:

- configure and deploy a project, based on a few template options
	who? Project proposer or administrator. (equality established once other participants are )
	- users (github username, legal name, wallet address, required investment, equity)
	- github repository (string)
	- purpose (string)
	- destroy process
	- process to add member
	- process to eject member
	: returns a legal contract referring to users, funds, and deployed smart contracts
- propose a task
	who? any project participant
	- owner
	- specifications (git commit)
	- budget
	- reward
	- duration
	- percent required to pass ** (could be adjusted subject to task budget's proportion of total funds - i.e. larger tasks require a larger quorum / majority)
	: returns taskId, to be used in voting
- vote on a proposed task
	who? any project participant (for now - could be much more complex)
	- taskId
	- [] Approve (2) or [] Reject (1)
	? change vote? just use AbsoluteVote rules
- submit evidence
	who? task owner, after task has been initiated and is in progress
	- git commit of evidence submission
	: evidenceVoteId, for evidence vote
- vote on evidence
	who? anyone
	- evidenceVoteId
	- vote 
