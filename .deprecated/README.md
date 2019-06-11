// in progress, compiled from a few sources


# The self-sovereign organization

*a DAO for small teams*

## Problem

People collaborate on creative efforts but lack an effective, intuitive, inexpensive and customizable way to define the terms and manage the informational and financials assets while their collaborative effort progresses. For lower-value products especially - say, a hackathon submission - it is rarely worth the time, effort and cost to engage a lawyer to draft the documents required to register a company; for longer-term projects, the costs of maintaining project management software and data storage often render the idea unviable and deter would-be collaborations. These burdens discourage people from engaging in projects that have some potential value, but do not meet the threshold of a full-blown startup. Further, organizations and governments experience friction when a new initiative requires database architectures to be designed, financial assets to be managed, and so on.

The self sovereign organization is an implementation of a DAO that seeks to solve these problems by offering project participants control over a project's data, money and code. By providing a framework for designing and initiating such an on-chain architecture, and managing assets through a project's life cycle, we hope to dramatically reduce barriers to entry for teams aiming to create something of value. Data permanence and transparency in project governance mechanisms are two primary advantages this approach offers.

We aim to make no assumptions about the users of these contracts and interfaces – so in a sense, we don’t know what their specific problem will be. However, the project intends to provide the outlines of a project management system that provides participants with a persistent and objective way to manage funds: collection, either from investors or customers, and disbursement, as payment or budget allocation. Further, our initial implementations of the system will provide a reporting mechanism, giving the team access the entire history of the project, the chain of evidence describing the effort as it progressed. The system is infinitely configurable, provided its implementers can code it. For this phase of the project, we aim to deploy simple functional prototypes to test; this working paper is meant to extend the idea beyond what is possible in this timeframe and into where things could go, with technical feasibility considered and implementation outlined.

## Proposal

We aim to provide a mechanism for groups to enter into a collaborative agreement, and clearly and fairly manage the project as it progresses.
At first, our product will allow people to launch a project, to be accessed via a web interface as a dApp, that enables participants to specify terms and enter into a clearly-defined agreement. Terms are entirely configurable, and are stored immutably; we expect a project’s initiation will only be valid if a threshold number of members agree by signing on.

We envision an evolving ecosystem of organizational types and use cases; our goal is to build and test a working dapp on the Ethereum blockchain that provides what we see as core functionality of the system, hoping that our open source code is cloned, developed on, extended. In this way, we may be able to expose organizational design to similar forces of innovation, evolution and natural selection that financial instruments are currently experiencing.

## Core Functionality

Any self-governed project will require a few components to offer any advantage over existing solutions to the challenge of operating an organization in the 21st century. Although the system could be used for managing projects with no intention of generating revenue, our initial target users are people who have an idea that may be valuable, but does not warrant formal incorporation – a hackathon team, maybe, or a group of tinkering colleagues keen on spinning off a side project. It is crucial to note: our interest is in designing a system that could serve groups of real people working in the real world. This means that it will need to comply with and complement existing legal, financial and business structures and systems, not operate outside them.

Core functions of the Project.sol contracts will include initiation, funding, task proposal, task voting, evidence submission and evidence voting.

### Initiation

At the outset of any project, the terms of the effort will need to be defined. This is by far the most important step in launching a project - inherent immutability means that once a team commits to entering into this agreement changing terms will only be as easy as was initially defined. Risks lie in tension here: if a mechanism for updating the rules is not included, a bug discovered or project gone awry may result in lost funds or unintende behavior. But such a mechanism will require some sort of authority to be executed, potentially leading to centralization and opening the system to abuse by a malicious actor. This challenge could be addressed by developing a democratic mechanism to update contract code.

Our research will seek to understand and define the configuration of these Project terms, and a workflow for inputting them into a smart contract and deploying it. In our MVP implementation some actions will occur off-chain, with tthe aim to integrate these into the on-chain functionality over time.

Aspects of the initiation phase will include defining the roles and expectations of each team member, their compensation scheme (thereby defining ownership / equity arrangements, vesting schedules etc), ways of confirming that the project is on track, methods to adapt or modify the terms of the system or participants therein, ways to arbitrate disagreements, clear indicators of when the project has outgrown the smart contract project management system and needs to be transitioned to some other structure, etc. Key to this step is trying to think through each potential outcome - wild success and abject failure. We suspect that it will be infeasible to address each and every one of these edge and corner case scenarios in the contract; instead, we will seek to offer a simple but complete mechanism for handling these situations, acknowledging that many solutions will rely on human judgment and a level of (perhaps incentivized) trust and off-chain coordination between participants.

By deploying a new contract instance, project initiators to pass information into the constructor function including a Github repository for data management (eventually to be transitioned to IPFS or some other decentralized data storage system), stated aims and intentions of the project, and other parameters defining project-level state variables. They will then be able to add collaborators, each of whom will have rights including task proposal, evidence submission, and voting on either. It is worth noting: for the MVP, each participant will have equal rights. But we see a great deal of potential in the ability for participants to configure roles, including each participant's equity stake, responsibilities, multiple reputations for more sophisticated voting mechanisms, access to various wallets and functions, etc. This will be highly project-specific.

We have, as part of our MVP, included a sample Ricardian contract, which is generated upon project initiation. This contract was designed to provide a link between the existing legal objective one deployed onto the blockchain, by expressly delegating authority to on-chain mechanisms and wallets for some decision making and funds storage. We would like to extend this to create the necessary documentation to frictionlessly register an entity with Companies House, thereby enabling the organization to open a bank account, purchase insurance, etc. Furthermore, functions could be implemented that would enable project participants to generate documentation compliant with jurisdictional requirements, such as annual accounting reports.

Once deployed any multiparty instance will almost certainly (again, subject to configuration) require signatures or even investment from different parties to validate project launch. This, along with signature of the Ricardian contract generated upon instance deployment, would constitute complete legal and programmatic initiation of our concept self sovereign organization.

## Project Management

Once launched, we expect project contracts to primarily serve as a place for participants to store and access project funds, access information about the state of the project, and to coordinate with other members towards successful execution. Suppose a project was configured to be executed on a two-week sprint cycle. At the end of each sprint, project participants would be required to submit evidence of their contributions. In our MVP, the `submitEvidence()` function accepts a GitHub commit hash that resolves to evidence submissions on the project Github repository, but in more fully featured implementations these might be IPFS hashes of work or evidence of work - photos, signed attestations from relevant stakeholders, perhaps even inputs from a connected sensor. A voting mechanism could enable other participants to confirm or refute that each other member pulled their weight that cycle, the outcome of which could determine remuneration or bonuses, or trigger some dispute resolution mechanism. The system will collect all critical information related to a project’s progress, available for review in perpetuity.

A further component of the system will be the automated payout of participants. Customers - or perhaps a service converting fiat card payments into cryptocurrency, like [paperclip lite](https://devpost.com/software/paperclip) - will send funds to a contract address. This contract address will process the funds according to defined terms - in a simple case, sending proportionate amounts to each of the participants according to equity stake.

## Disputes

This concept was inspired in part by the experience of failing to anticipate disputes arising in an entrepreneurial venture and seeing adverse consequences for both the company and the interpersonal relationships of those running it. Dispute handling will probably be one of the most difficult aspects to get right - only experience will reveal embedded misjudgments and oversights in system design. For this reason, we will likely recommend that early project iterations remain constrained in scope (time, resource, team and revenue - small is beautiful) and offer owners the option to change or terminate the contract by meeting a relatively low threshold. The main drawback to this - centralization of authority - is worth the confidence knowing that we can revert to traditional systems at a relatively low cost while we learn best security practices.

Dispute resolution will be a core research area of our team; we anticipate implementing simple mechanisms in code while providing a much more thorough examination of the topic in an accompanying document. Further, we hope to build on existing efforts to decentralize arbitration using web 3 technologies. Our guiding principles will be the minimization of cost, a layered escalation to more absolute forms of authority (including, eventually, the jurisdictional

 government’s justice system), a base hope that participants will be reasonable and a base assumption that they may not be.
Adjusting the terms
In the initiation terms of the project, it will be important to include some way to adjust the terms during project execution. This may mean dropping or adding members, adjusting equity, or even entirely transferring ownership - selling the project. We hope to design and implement a number of these features, though, again, expect much of the potential here to be discussed in a document but not implemented in code.
Project Dissolution
How a project ends will need to be defined at its outset. We expect that different termination events will be triggered by different project conditions. For example, a team could agree at the outset that if a project generates over $1000 in revenue for 3 consecutive months, some function is executed that causes participants to register a formal company. Alternatively, a project could be dissolved - and funds invested returned - if early milestones aren’t met by a deadline. We will consider a broad spectrum of options in this arena, and implement a few of the most common ones in our prototype.

## A Final Core Component

The final challenge of building a fully functional system is related to privacy. The system is severely constrained if project participants don’t have the option to keep data stored on chain private; much of the point is defeated if this implementation relies on storing it in secure off-chain databases, a private blockchain instance, etc. Our solution to this problem will rely on a mechanism to manage keys, enabling the proper participants the ability to grant or revoke access to data in its decrypted state (i.e. to decryption keys of stored encrypted data). This will have constraints, of course - revocation is impossible if a participant makes a copy of a decrypted file while they still have access - but we suspect that granting and revoking access still may have some value.

## Questions

Huge questions remain about legal structures, liability, harmonization with off-chain payments systems etc. At this point our aim is to make no assumptions about the nature of the projects that would be implemented, instead providing template contracts and recommendations on how to effectively and securely operate these projects.

A more advanced implementation of the system could be a collective existing under a single umbrella company; participants could enter into these projects with other members (and external collaborators) fluidly and the company (which would receive a proportion of all income) could provide services to all members that no one could justify the cost of. Liability issues would be especially acute here.

Potential Tech

Ethereum. IPFS. Mattereum. DAOstack. Gnosis Safe. MakerDAO (DAI). NuCypher. Open banking APIs. Democracy.earth. Metamask. Web3.js.
Related Projects
