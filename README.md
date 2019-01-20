# Future of Blockchain : LBL DAO Entry

An implementation of a self-sovereign organization, designed by and for project participants.

[Project proposal](./self-sovereign-org-proposal.pdf).

## Components / Deliverables

### Whitepaper

A research paper describing the problem, defining terms, critically exploring solutions or possible implementations and laying out future research.

### Prototype

A functional prototype deployed on an ethereum testnet, with some traditional back-end architecture (server, off-chain databases).

Major question: privacy. Are all on-chain data / IPFS-addressed content encrypted? With which key?

  *Nucypher* FHE library and proxy re-encryption scheme

**Users**

Participants
Clients / customers
Arbitrators
...?

#### Front end

**Interfaces**

Deploy project
Participants accept terms (multisig to initiate project)
Accept / distribute funds (is this an interface?)
  Payment

  Budget allocation

Submit evidence / deliverable

  Evidence review (multisig)

    approve - execute terms

    revise

    contest / reject - divert to arbitration

  Should trigger notification to reviewers

Project dashboard (who can view?)

  Users (contact details?)

  Assets (i.e. submissions)

  Tasks (upcoming, awaiting review, approved, disputed)

    Calendar view

    Owner view

    Category view

    Status view

*React*

*web3.js*

#### Back end

**EVM**

deploy project

user accept role

accept / disburse funds

create / update task (ongoing - agile)

submit / review evidence

(see rough [sso.sol]('./contracts/sso.sol'))

*Solidity*

*Gnosis Safe*

*Nucypher*

#### Traditional server

Server hosting website, cache of project-relevant files (IPFS node? SQL or mongo database?)

*Node*

*mongodb*

*web3.js*
