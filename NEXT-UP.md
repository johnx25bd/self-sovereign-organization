

FINAL PUSH



# Research

- Organize concept note, Ricardian research, possibly homomorphic encryption research into one research paper
- Add in ?????

# Ricardian contracts

- Write draft legal contract (Amanda)
- Review and adapt draft legal contract
  - identify templateable spots
    - People. Legal name. Github username. Ethereum wallet address.
    - Funds or investment
    - Contract address
    - Voting schemes (???)
    - Specify off-chain communication (i.e. task proposer transmitting taskId to other participants)
    - Adding and ejecting participants
  - Add in appendices - ABI, Contract code, constructor parameters, bytecode
- Draft Ricardian contracts section of research paper
  - Arbitration
  - Companies House compatibility
  - Docusign or other digital signatures
  - [This research](./research/RICARDIAN.md)

# Prototype

- Design front end interfaces (John)
  - Initiate project
    - Download Ricardian contract PDF
  - Propose task
  - Submit evidence
  - Vote on task
  - Vote on evidence
- Develop front end interfaces (John)
- Integrate web3.js with front end interfaces (John, Alex)
- Build pdf generator in JS using inputs, contract address, bytecode, ABI etc (Alex, John) OR output a txt file ...

- get Project.sol compiling (Alex, John, Isaac)
- Deploy on testnet (Alex, John, Isaac)
- Do some testing (Alex, John)

- projectFactory contract ... ?


## Development - next up

Review and tidy contract state variables and structs
Complete voting integration (DAOstack Infra) - task proposals and evidence submissions

> propose task, submit evidence are almost complete. Refactored vote() to apply to both ballot types. Need to work out tally and handling winner. Build in

Build out Task struct definition


Look into implementing Roles (if we want to include multiple roles ...)
Unit test the fuck out of it



## Development - soonish

Design and develop front end interfaces
- Propose task
- Vote (task proposal OR task evidence)
- Submit evidence
Look into ProjectFactory contract development
Work out Gnosis Safe multisig access to contract funds
  At any point, if all participants unanimously want to send funds out, they can . . .
Work out how to work with DAI instead of Ether
