# Core team configures project

A team of five people - Alice, Bob, Charlotte, Duncan and Ella - decide to come together and create something. In this case, they want to create a website that will offer a simple function: displaying the nearest hospital to a point selected on a map, plus information on how to contact emergency services. Alice and Bob are developers, Charlotte and Duncan are designers, and Ella is a travel professional (international tour guide). They hope that the tool will be used by travelers in places they aren't familiar with.

Each of the core team members will be equals in this project: there is no team lead. Each has their own strengths and weaknesses and decide that they want to split everything evenly: responsibilities and profits. They plan to advertise on the website, and have plans of licensing the technology to travel app companies *if things go well and a certain number of monthly users is reached*. However, each of them have full time jobs and don't want to dedicate too much time to this - they hope to have a functional web app running within 3 months, and not be required to do much in terms of upkeep once it is built.

Each of them agrees to invest $300 to the project, expecting 2/3rds of that to be returned to them when they successfully complete deliverables and 1/3rd to go towards costs, primarily for a domain name, web hosting services and potentially fees for API calls.  

They meet and set out the terms of their collaboration:
- Each will share an Ethereum wallet address they control with the group. This will be their primary way to interact with the project.
- Once all five have submitted their investment in the form of DAI, the project is initiated.
- Tasks can be proposed by anyone on the team.
- Task proposals will include a detailed specification of the expected output (i.e. deliverable), a task owner, a deadline, a budget and a reward (compensation).
- A simple majority will determine whether tasks are accepted.
  - If accepted, the budget is released to the task owner (or a contract controlled by the task owner) to spend.
  - If rejected, the task is burned. A revised iteration of the task can be proposed, but this is an independent action.
- Once the task owner has completed their task, they are required to submit evidence of completion to the contract.
- Upon receipt of evidence, all the other team members must review the evidence to assess whether it meets the criteria set out at task.
  - If a majority of voters agree (i.e. 3/4), the task is either marked as completed or rejected.
  - If completed, the reward is distributed to the task owner as compensation.
  - If rejected, the reward is distributed to the project contract and the task is reset
- Any member can be ejected from the group by unanimous vote by the other 4 members
  - If ejected, the member is returned 1/3rd of their unspent contribution to the project.
- Once the website is completed and project completed (as approved by 4 / 5 vote) ... what happens?
- At any point if 4 / 5 members vote to dissolve the organization, money is returned proportionately to each member and the contract ceases to function.
- Upgrade? i.e. transfer contract and contents to another contract.

Having clearly defined these terms, Alice and Bob develop solidity contracts encoding the terms and deploy the system onto the Ethereum blockchain, providing the Avatar address to each participant to submit funds to trigger project initiation.
