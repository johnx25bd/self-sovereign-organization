// Web3 setup


var jsonInterface, // load from projectFactory ABI ....
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
      // web3.eth.sendTransaction({ /* ... */ });
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


  (async (web3) => {
    accounts = await web3.eth.getAccounts();

  })(web3);

  $.getJSON('/build/contracts/Project.json', (json) => {
    jsonInterface = json;

    projectOptions = {
      abi: jsonInterface.abi,
      data: jsonInterface.bytecode,
      arguments: ['repo', accounts[0], 'string', 'string', 'string', accounts[0], 100, 100]
    };

    project = new web3.eth.Contract(projectOptions.abi, null, projectOptions);

    console.log('YO')
    // project.deploy();

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

  projectFactory.methods.createProject('github', accounts[0], 'st', 'st', 'st', accounts[0], 100)
    .send({
      from: accounts[0]
    })
    .on('receipt', (receipt) => {
      console.log(receipt);
    });

  // here we will call:

  // projectConstructor.methods.deployProject(deployData)
  //   .on('deployed', function (contractAddress) { // this will be an event upon successful invocation of deployProject() that returns the new contract instance's address
  //     generateRicardianContract(formData, contractAddress);
  //   });

})



function processFormData(_formData) {

  // process _formData into a format compatible with deployProject invocation
  // Be sure to account for the variable number of participants ....

}


function generateRicardianContract(_formData, _jsonInterface) {
  // note: jsonInterface has ABI, (projectFactory) source code and bytecode
  // will need to load in Project.json ...
  var ricardianContract = new jsPDF();
  ricardianContract.setFontSize(40);
  ricardianContract.text(35, 25, "Octonyan loves jsPDF");
  ricardianContract.save('contract.pdf');
}
