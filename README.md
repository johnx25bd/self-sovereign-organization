# Sovereign Project: autonomous organizations for a web3 world

## Team members

Amanda Tan
Alex Zakharov
Isaac Sultan
John Hoopes IV

## What is your idea?

Blockchains and smart contracts offer a new way for people to manage their informational and financial assets without relying on centralized companies and authorities. Besides creating scarcity (and therefore value) in the informational space, the persistence and immutability of data on distributed ledgers may provide opportunities for information and value management systems that are much lower cost and more transparent than existing solutions.

DAOs seek to capitalize on the ability to make collective decisions about management of stores of value by creating governance mechanisms that enable participation of large groups of uncoordinated, or even adversarial, entities. Most research into DAOs seems to be focused on A. managing financial assets and B. very large (and truly decentralized) groups of participants.

The self sovereign organization is a form of an autonomous organization designed to enable participants to manage information and money as they pursue some objective. It is, essentially, a dapp for project management, with task selection and fund storage and allocation based on governance mechanisms *that are entirely configurable by project participants*. We see many applications for more sophisticated implementations of our MVP, including very early stage collaborative projects, management of very long term projects, intra-organizational budget and task management systems, and possibly even intra- and intergovernmental task, information and financial management.

## Anything else

Our project explored several concepts related to autonomous organizations and practical ways to drive their adoption in a world beginning its transition to web3 technologies.

We focused on small organizations, ones that might not have a central authority but are not entirely decentralized, like most early-stage collaborative efforts are. People know each other, can coordinate off chain, and even trust each other, to an extent. This project was designed with them in mind, to offer a way for them to securely and cheaply keep the information and money they need to pursue their collective goals. We also hoped to offer them a chance to clarify ambiguity at the outset of a project, something that we've failed to do in the past, to the detriment of the project and our relationships. And we focused on managing informational assets besides money, namely, tasks, by providing a mechanism for participants to propose tasks, vote to accept them (including disbursement of budgets), submit evidence of task completion, and approve or reject the evidence, triggering smart contract logic at each step. It is worth re-emphasizing: the system is infinitely configurable by project participants. We make no assumptions about their organization or management, and leave it up to them to decide if, upon reading the code, they want to enter into the arrangement according to whatever terms are defined in the smart contracts.

We also sought to take a pragmatic approach towards adoption, and wanted to provide some legal document to complement the establishment of an instance of our MVP Project.sol contract on the Ethereum blockchain. To this end, we developed a template legal contract agreement, compiled upon project deployment, for each participant to sign. Of course, much further research is needed, but we are excited to have a prototype Ricardian contract, which explicitly references the wallet addresses owned by project participants along with their legal names as well as the contract address where the project instance is deployed on the EVM. Source code, bytecode and ABIs are included with these legal contracts, providing hooks for future machine interoperability. We were motivated to implement these Ricardian contracts because we see the web3 being adopted fastest if dapps are designed to complement and comply with existing regulations. In our accompanying concept note we investigated further complementing components such as generating documents to register an organization with Companies House, or to generate compliant annual financial statements.

We will continue to develop this project: we designed and built it for ourselves, and are close to having a functional prototype to test on short term projects dealing with small budgets. We focused on getting the Solidity code functional, but much testing is in order, plus development of more fully featured front end interfaces (which will likely be supplemented with a traditional node server / back end infrastructure) to create a seamless, intuitive user experience in engaging with projects. We are looking for support in the form of ideas, testers, developers, designers, mentors and advisors, etc. We are not actively looking for funding at this time but would be open to a conversation, and appreciate any suggestions for appropriate grants.
