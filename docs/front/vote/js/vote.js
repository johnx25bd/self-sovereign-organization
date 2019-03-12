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

});


var formData;

// Event handlers

$('#deploy').on('click', function(e) {
  e.preventDefault();
  formData = $("form").serializeArray();

  project.options.address = formData[0].value;

  if (formData[3].value == 'evidence') {
    project.methods.voteOnEvidence(
      formData[2].value,
      formData[4].value
      )
      .send({
        from:     formData[1].value,
        gas: 15000000,
        gasPrice: '2000000000'
      })
      .on('receipt', (receipt) => {
        console.log("========== Evidence Voted ==========");
        console.log(receipt); // this should have contract address ...

      });
  } else {
    project.methods.voteOnTaskProposal(
      formData[2].value,
      formData[4].value
      )
      .send({
        from:     formData[1].value,
        gas: 15000000,
        gasPrice: '2000000000'
      })
      .on('receipt', (receipt) => {
        console.log("========== Task Proposal Voted ==========");
        console.log(receipt); // this should have contract address ...

      });
  }

})
