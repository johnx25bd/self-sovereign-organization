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




# Equity

Each participant will be expected to contribute their share.

## Expected contributions:

John IV - manage project. Solidity, front end, back end development. Support design. Support research.

Alex Z - research and write DAO section of research paper. Solidity development and support.

Amanda T - research and write Ricardian contracts section of research paper. App testing.

Lorcan D - research and write privacy section of research paper. Solidity and web3.js code review. App testing.

Isaac - Prototype app architecture design. Full stack code support and review. App testing.

Tobias - UI development support. App testing.

Alex T - UX / UI designs. App testing.

At the end we will each assess ourselves and every other participant in the project based on the extent to which we delivered on our expected contribution. If there is a discrepancy between self- and group perceptions, the average of all perceived contributions will be deemed the appropriate proportionate contribution. Ongoing documentary evidence of work will do a great deal to show contribution and ensure value of effort is captured throughout the duration of the project. 
