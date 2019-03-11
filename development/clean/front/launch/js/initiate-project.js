// Web3 setup


var jsonInterface, // load from actory ABI ....
  web3,
  project,
  projectOptions,
  accounts,
  jsonInterface;

window.addEventListener('load', async () => {
  if (false && window.ethereum) {
    window.web3 = new Web3(ethereum);
    try {
      await ethereum.enable();
      console.log("ETHEREUM ENABLED");

    } catch (error) {
      // throw error;
    }
  } else if (false && window.web3) {
    window.web3 = new Web3(web3.currentProvider);
    // web3.eth.sendTransaction({ /* ... */ });
  } else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
    console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
  }

  $.getJSON('../../build/contracts/Project.json', (json) => {
    jsonInterface = json;

    (async (web3) => {
      accounts = await web3.eth.getAccounts();

      projectOptions = {
        abi: jsonInterface.abi,
        data: jsonInterface.bytecode,
      };

      project = new web3.eth.Contract(projectOptions.abi, null, projectOptions);

    })(web3);
  });

  let latestBlockNum;

  web3.eth.getBlockNumber()
    .then((blockNum) => {
      latestBlockNum = blockNum;
    });

  // project.events.projectCreated({}, (error, event) => {
  //     console.log('YAHHHHH', event);
  //   })
  //   .on('data', (event) => {
  //     console.log(event); // same results as the optional callback above
  //   })
  //   .on('changed', (event) => {
  //     // remove event from local database
  //   })
  //   .on('error', console.error);
});






var participantCt = 1;
var formData;

var addParticipantHTML = function() {
  var pCt = participantCt.toString();

  return `<div class="form-group participant">
    <span class="col-md-1 col-md-offset-2 text-center">Participant ` + pCt + `</span>
    <div class="col-md-12">
      <input name="participantName` + pCt + `" type="text" placeholder="legal name" class="form-control">
    </div>
    <div class="col-md-12">
      <input name="participantGithubUsername` + pCt + `" type="text" placeholder="github username" class="form-control">
    </div>
    <div class="col-md-12">
      <input name="participantWalletAddress` + pCt + `" type="text" placeholder="wallet address" class="form-control">
    </div>
  </div>`
}

// Event handlers

$('#addParticipant').on('click', function(e) {
  e.preventDefault();
  participantCt += 1;
  $(addParticipantHTML()).insertAfter($('.participant').last());
})


$('#deploy').on('click', function(e) {
  e.preventDefault();
  formData = $("form").serializeArray();
  // process form data
  var deployData = processFormData(formData);
  console.log(deployData);

  deployArgs = [deployData.projectGithub,
    deployData.offeror.name,
    deployData.offeror.github,
    deployData.projectPurpose,
    String(web3.utils.toWei(String(deployData.requiredPayment.value), 'ether')),
    deployData.requiredNumberPaid.value,
    '50',
    '1'

  ]

  project.deploy({
      data: jsonInterface.bytecode,
      arguments: deployArgs
    })
    .send({
      from: accounts[0],
      gas: 15000000,
      gasPrice: '2000000000'
    })
    .on('receipt', (receipt) => {
      console.log(receipt); // this should have contract address ...
      project.options.address = receipt.contractAddress;
      generateRicardianContract(deployData, receipt.contractAddress, jsonInterface);

      deployData.offerees.forEach((offeree) => {
        project.methods.addParticipant(offeree.wallet, offeree.name, offeree.github)
          .send({
            from: accounts[0],
            gas: 15000000,
            gasPrice: '2000000000'
          }).on('receipt', (receipt) => { console.log(receipt); });
      })
      // project.methods.addParticipant([])

    });
})

function processFormData(_formData) {

  // process _formData into a format compatible with deployProject invocation
  // Be sure to account for the variable number of participants ....
  var fLength = _formData.length;
  var rData = {
    offeror: {},
    offerees: [],
    projectName: "",
    projectGithub: "",
    projectPurpose: "",
    date: ""
  };

  var participants = _formData.slice(4, fLength - 4);
  rData.projectName = _formData[0].value;
  rData.projectGithub = _formData[fLength - 2].value;
  rData.offeror.name = _formData[1].value;
  rData.offeror.github = _formData[2].value;
  rData.offeror.wallet = _formData[3].value;
  rData.projectPurpose = _formData[fLength - 1].value;
  rData.requiredNumberPaid = _formData[fLength - 4];
  rData.requiredPayment = _formData[fLength - 3]
  rData.offerees = []

  for (var i = 0; i < participants.length; i += 3) {
    var offeree = {
      name: participants[i].value,
      github: participants[i + 1].value,
      wallet: participants[i + 2].value
    };

    rData.offerees.push(offeree);
  }

  return rData;
}

String.prototype.replaceAll = function(search, replacement) {
  var target = this;
  return target.replace(new RegExp(search, 'g'), replacement);
};

function generateRicardianContract(_formData, _contractAddress, _jsonInterface) {
  // note: jsonInterface has ABI, (projectFactory) source code and bytecode
  // will need to load in Project.json ...
  // Loop through form data
  var contractsPack = [];
  var contractData = _formData;

  _formData.offerees.forEach((offeree) => {
    var contract = ricardianContractData.template;
    contract = contract.replace(/\[OFFEROR'S NAME\]/g, contractData.offeror.name)
      .replaceAll(/\[PROJECT NAME\]/g, contractData.projectName)
      .replaceAll(/\[OFFEROR'S SERVER USERNAME\]/g, contractData.offeror.github)
      .replaceAll(/\[OFFEROR'S WALLET ADDRESS\]/g, contractData.offeror.wallet)
      .replaceAll(/\[DATE\]/g, new Date().toDateString())
      .replaceAll(/\[OFFEREE'S NAME\]/g, offeree.name)
      .replaceAll(/\[OFFEREE'S SERVER USERNAME\]/g, offeree.github)
      .replaceAll(/\[OFFEREE’S WALLET ADDRESS\]/g, offeree.wallet)
      .replaceAll(/\[CONTRACT ADDRESS\]/g, _contractAddress)
      .replaceAll(/\[GITHUB REPOSITORY\]/g, contractData.githubRepo)
      .replaceAll(/\[REQUIRED NUMBER PAID\]/g, contractData.requiredNumberPaid)
      .replaceAll(/\[REQUIRED PAYMENT\]/g, contractData.requiredPayment);

    contractsPack.push({
      name: offeree.name,
      c: contract
    });
  });

  var zip = new JSZip();
  console.log(contractsPack);
  contractsPack.forEach((contract) => {
    var folder = zip.folder()
      folder.file(contract.name + " - " + contractData.projectName + " contract.txt", contract.c);
      folder.file('Project.sol', jsonInterface.source);
      folder.file('Project.json', jsonInterface.bytecode);
  })

  zip.generateAsync({
      type: "blob"
    })
    .then(function(content) {
      console.log('content', content);
      // Force down of the Zip file
      saveAs(content, contractData.projectName + " Ricardian Contracts.zip");
    });

  // download(contractsPack[0].name + " contract.txt", contractsPack[0].c);
}

//
// function download(filename, text) {
//   var element = document.createElement('a');
//   element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
//   element.setAttribute('download', filename);
//
//   element.style.display = 'none';
//   document.body.appendChild(element);
//
//   element.click();
//
//   document.body.removeChild(element);
// }

var ricardianContractData = {
  template: `
    [OFFEROR'S NAME]

    and

    [OFFEREE'S NAME]


    ___________________________________________________________________________


    PROJECT [PROJECT NAME] COMMENCEMENT AGREEMENT
    ___________________________________________________________________________

    1.    DEFINITION AND INTERPRETATION    1
    2.    TERM OF EMPLOYMENT    1
    3.    DUTIES    2
    4.    PLACE OF WORK    2
    5.    HOURS OF WORK    3
    6.    SALARY    3
    7.    PENSIONS    3
    8.    HOLIDAYS    3
    9.    SICKNESS ABSENCE    4
    10.    BENEFITS    5
    11.    CONFIDENTIAL INFORMATION    5
    12.    INTELLECTUAL PROPERTY    6
    13.    PAYMENT IN LIEU OF NOTICE    7
    14.    OBLIGATIONS ON TERMINATION    8
    15.    DISCIPLINARY AND GRIEVANCE PROCEDURES    9
    16.    DATA PROTECTION    9
    17.    COLLECTIVE AGREEMENTS    10
    18.    SECTION ONE STATEMENT    10
    19.    ENTIRE AGREEMENT    10
    20.    VARIATION    10
    21.    COUNTERPARTS    10
    22.    THIRD PARTY RIGHTS    10
    23.    GOVERNING LAW AND JURISDICTION    10


    THIS AGREEMENT is signed as a CONTRACT and dated [DATE].

    PARTIES

    (1)     [OFFEROR'S NAME], registered and residing in England and Wales, Github username [OFFEROR'S SERVER USERNAME] whose registered wallet is [OFFEROR'S WALLET ADDRESS] (the “Wallet Address”).

    (2)    [OFFEREE'S NAME], Github username [OFFEREE'S SERVER USERNAME] (“You”), whose registered wallet address is [OFFEREE’S WALLET ADDRESS],

    DEFINITION AND INTERPRETATION
    In this Agreement:
    The headings in this Agreement are inserted for convenience only and shall not affect its construction.
    A reference to a particular law is a reference to it as it is in force for the time being taking account of any amendment, extension, or re-enactment and includes any subordinate legislation for the time being in force made under it.
    Words in the singular include the plural and in the plural include the singular.
    The words “include” or “including” will be construed as meaning without limitation.
    As used in this Agreement, the following terms shall have the meanings set forth below:
    “Date of Deployment” shall refer to the date the project commences as a result of a positive vote result within the community for the Offeree to undertake a given task, a given set of tasks and/or any other forms of undertakings agreed upon by the Offeror, the Offeree and the Community;
    “Task” shall mean a particular set of action and/or undertaking undertaken by the Offeree of which the Offeree assumes responsibility and ownership upon the date of deployment for which completion of his undertakings entitle him to a Reward;
    “Reward” refers to the financial or non-financial gains agreed upon by the Offeror, the Offeree and the Community, provided to the Offeree as a form of consideration in exchange for the completion of the undertakings expressly agreed upon on the Date of Deployment;
    “Project” shall mean a set of tasks aimed at contributing to a singular or group of objective(s) with a Project Contract Address [CONTRACT ADDRESS] on the Ethereum mainnet;
    “Server” shall refer to the Github repository at [GITHUB REPOSITORY] where the Project informantional assets are stored;
    “Decentralised Autonomous Organisation (DAO)” shall refer to the server that is represented by rules encoded as a computer programme that is transparent, controlled by the shareholders and not influenced by any central authority;
    “Smart Contract” refers to the computer protocol intended to digitally facilitate, verify, or enforce the negotiation of a contract in the programming language, Solidity;
    the “Vote” refers to the executions of various voting functions (for e.g. voteOnTask function) that expresses agreement, dissent or abstinence from voting pertaining to a certain action and/or directive, of an individual with the right to vote within the project community, where the collective results lead to a determinate binary outcome of either pass or fail;
    “Community” refers to the a group of people working on or spectating the commencement or completion of a project; and
    “Task Acceptance” refers to the process decided in accordance with the outcome based on the voting procedure defined in Section 1.2 (d).
    The schedule to this Agreement forms part of and is incorporated into this Agreement.
    TERM OF PROJECT EMBARKATION
    Your embarkation of the project (the "Project") shall commence on [DATE] and shall continue, subject to the remaining terms of this Agreement, until terminated by either party giving the other not less than 2 weeks' notice (the "Project Forefeiture Duration”) or where otherwise decided via by the simple majority of the Community through voting (the “Vote”) in which case you will not be entitled to receive the reward that was earlier determined, promised and agreed upon.
    No previous project(s) with a previous offeror or any related offerors count towards the completion of the Project unless otherwise stated by the Offeror and the Project is independent and separate of other projects unless otherwise explicitly stated.
    DUTIES
    You will be expected to complete the tasks assigned to you through the Project instance smart contract logic and submit evidence of the completed work or work in progress (the “Evidence”) to the contract addres [CONTRACT ADDRESS].
    The Project becomes active once [REQUIRED NUMBER PAID] of proposed participants submit [REQUIRED PAYMENT] ether to the project instance's fund() method. [Your duties and task requirements are set out in Schedule 1.] (the “Requirements Document”)
    During the embarkation of the task you shall:
    comply with all reasonable and lawful directions given to you by the Offeror;
    comply with the Offeror’s requests, rules and regulations in place from time to time in force;
    report your own wrongdoing and any wrongdoing or proposed wrongdoing related to the completion and embarkation of the Task to the Offeror immediately upon becoming aware of it; and
    consent to the offeror’s and server’s monitoring and recording any use that you make of the server’s electronic communications systems for the purpose of ensuring that the offeror’s and server’s rules are being complied with and for legitimate business purposes.
    You represent and warrant to the Offeror that, by entering into this Agreement or performing any of your obligations under it, you will not be in breach of any court order or any express or implied terms of any contract or other obligation binding on you.
    You warrant that you are entitled to work on this project in your country of residence without any additional approvals and will notify the Offeror immediately if you cease to be so entitled at any time during the Task.
    PLACE OF WORK
    Your normal place of work is or such other place as the Offeror may reasonably require for the proper performance and exercise of your duties.
    HOURS OF WORK
    Your normal working hours shall be flexible as what is required for the completion of the tasks undertaken by the Offeree of which he assumes responsibiilty and ownership unless otherwise stated and agreed upon in the Requirements Document. You may be required to work outside these hours as may be necessary for the proper performance of your duties. You acknowledge that you shall not receive further remuneration or time off in lieu in respect of additional hours worked outside your normal hours and that the Reward is for the completion of the task in adherence to the Requirements Document and any additional Reward is only applicable where prior agreement on providing the additional Reward was met. Lunch breaks and other breaks provided to you shall not constitute working time.
    REWARD
    You shall be provided a Reward, stated and outlined in the Requirements Document, based on the completion of the tasks undertaken within the project, subject to the Requirements Document in which the Offeror can choose to provide the reward in tranches based on individual tasks completed, a set of tasks completed or as otherwise indicated in the Requirements Document.
    The Reward will be sent to your Wallet Address as outlined in the Agreement by the Offeror, of which the DAO is explicitly obligated to have paid you in full upon the completion of the Task.
    PENSIONS, BENEFITS AND HOLIDAYS
    The Offeror hereby declares that this contract does not indicate employment and hence, confirms that any pension, additional fixed sum payments, benefits and holidays are not applicable to this contract or any work relating to the Task.
    A contracting-out certificate is not in force in respect of your employment.
    CONFIDENTIAL INFORMATION
    In this Agreement “Confidential Information” means information (whether or not recorded in documentary form, or stored on any magnetic or optical disk or memory) relating to the business, products, affairs and finances of the Offeror for the time being confidential to the Offeror or any related entities and trade secrets including, without limitation, technical data and know-how relating to the business and work of the Offeror or any or any or any of its or their business contacts.
    You acknowledge that in the course of the employment you will have access to Confidential Information. You shall not (except in the proper course of your duties), either during the employment or at any time after its termination (however arising), use or disclose to any person, company or other organisation whatsoever (and shall use your best endeavours to prevent the publication or disclosure of) any Confidential Information. This shall not apply to:
    any use or disclosure authorised by the Company or required by law;
    any information which is already in, or comes into, public domain other than through your unauthorised disclosure; or
    INTELLECTUAL PROPERTY
    For the purposes of this clause:
    Intellectual Property Rights means patents, rights to Inventions, copyright and related rights, trade marks, trade names and domain names, rights in get-up, rights in goodwill or to sue for passing off, unfair competition rights, rights in designs, rights in computer software, database rights, topography rights, rights in confidential information (including know-how and trade secrets) and any other intellectual property rights, in each case whether registered or unregistered and including all applications (or rights to apply) for, and renewals or extensions of, such rights and all similar or equivalent rights or forms of protection which subsist or will subsist now or in the future in any part of the world; and
    Invention means any invention, idea, discovery, development, improvement or innovation, whether or not patentable or capable of registration, and whether or not recorded in any medium.
    You shall give the Offeror full written details of all Inventions and of all works embodying Intellectual Property Rights made wholly or partially by you at any time during the course of your employment.  You acknowledge that all Intellectual Property Rights subsisting (or which may in the future subsist) in all such Inventions and works shall automatically, on creation, vest in the Company absolutely.  To the extent that legal title in any such Inventions and/or Intellectual Property Rights does not vest in the Offeror automatically and/or by virtue of this clause, you agree, immediately on creation of such Inventions and/or Intellectual Property Rights, to offer to the Offeror in writing a right of first refusal to acquire them on arm’s length terms to be agreed between the parties. If the parties cannot agree on such terms within 30 days of the Company receiving the offer, the Offeror shall refer the dispute for determination to an expert who shall be appointed by the President of the London Court of International Arbitration.  The expert’s decisions shall be final and binding on the parties in the absence of manifest error, and the costs of arbitration shall be borne equally by the parties.  You agree that the provisions of this clause shall apply to all such Inventions and/or Intellectual Property Rights until such time as the Company has agreed in writing that you may offer them for sale to a third party.  You agree promptly to execute all documents and do all acts as may, in the opinion of the Company, be necessary to give effect to this clause.
    You hereby irrevocably waive all moral rights under the Copyright, Designs and Patents Act 1988 (and all similar rights in other jurisdictions) which you have or will have in any existing or future works referred to in clause 12.2.
    You hereby irrevocably appoint the Offeror to be your attorney to execute and do any such instrument or thing and generally to use your name for the purpose of giving the Offeror or its nominee the benefit of this clause and acknowledge in favour of a third party that a certificate in writing signed by any director or the secretary of the Company that any instrument or act falls within the authority conferred by this clause shall be conclusive evidence that such is the case.
    OBLIGATIONS ON TERMINATION
    On terminating the completion of the Task (however arising) you shall:
    immediately deliver to the Offeror all documents, books, materials, records, correspondence, papers and information (on whatever media and wherever located) relating to the business or affairs of the Offeror or its business contacts, any keys, credit card and any other property of the Offeror including any car provided to you, which is in your possession or under your control;
    irretrievably delete any information relating to the business of the Offeror stored on any magnetic or optical disk or memory and all matter derived from such sources which is in your possession or under your control outside the Offeror’s premises; and
    provide a signed statement that you have complied fully your obligations under this clause 14.1 together with such reasonable evidence of compliance as the Company may request.
    the Company may require you not to contact or deal with (or attempt to contact or deal with) any officer, employee, consultant, client, customer, supplier, agent, distributor, shareholder, adviser or other business contact of the Company.
    DATA PROTECTION
    The Offeror and/or the Server will collect and process information relating to you in accordance with the privacy notice which you have agreed to upon using the Server as part of its terms and conditions of usage.
    You shall comply with the Privacy Standard when handling personal data in the course of employment including personal data relating to any employee, worker, contractor, customer, client, supplier or agent of the Company. You will also comply with the Server’s [Electronic Information and Communications Systems Policy].
    Failure to comply with the Privacy Standard or any of the policies listed above in Clause 16.2 may be dealt with under our disciplinary procedure and, in serious cases, may be treated as gross misconduct leading to summary dismissal.
    COLLECTIVE AGREEMENTS
    There is no collective agreement which directly affects the completion of your Task.
    ENTIRE AGREEMENT
    This Agreement is the entire agreement between you and the Offeror and replaces all previous agreements and arrangements (whether written or verbal, express or implied) relating to your arrangements and agreements with the Offeror and your confirm that in entering into this Agreement you have not relied on any representations, promises or assurances which are not contained in this Agreement.
    Nothing in this Agreement shall limit or exclude any liability for fraud.
    VARIATION
    No variation or mutually agreed termination of this Agreement shall be effective unless it is in writing and signed by the parties (or their authorised representatives).
    COUNTERPARTS
    This Agreement may be executed in any number of counterparts, each of which, when executed, shall be an original, and all the counterparts together shall constitute one and the same instrument.
    THIRD PARTY RIGHTS
    No term of this Agreement will be enforceable by a third party in his own right by virtue of section 1(1) of the Contracts (Rights of Third Parties Act) 1999 and for the avoidance of doubt this Agreement may be rescinded or varied (whether in whole or in part) by agreement between you and the Offeror without the consent of any third party.
    GOVERNING LAW AND JURISDICTION
    This Agreement any dispute or claim arising out of or in connection with it or its subject matter or formation (including non-contractual disputes or claims) shall be governed by and construed in accordance with the law of England and Wales.
    The parties irrevocably agree that the courts of England and Wales shall have exclusive jurisdiction to settle any dispute or claim that arises out of or in connection with this Agreement or its subject matter or formation (including non-contractual disputes or claims).


    This Agreement has been entered into on the date stated at the beginning of it.

    Signed as a CONTRACT by [OFFEROR'S NAME]


    Offeror                 Date

    in the presence of:


    Witness                 Date


    Signed as a CONTRACT by [OFFEREE'S NAME]


    Offeror                 Date

    in the presence of:


    Witness                 Date
    `,

};
