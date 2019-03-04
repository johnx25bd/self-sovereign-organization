
// Web3 setup

var jsonInterface; // load from projectFactory ABI ....
var address; // should be contract address .... i.e. projectFactory address

var web3 = new Web3();

if (window.ethereum) {
  const ethereum = window.ethereum
  const web3Provider = new Web3(ethereum)

  /* make web3Provider available to your entire app now */
}
// var projectConstructor = new web3.eth.Contract(jsonInterface, address);

// Form data manipulation and handling

var participantCt = 1;
var formData;

var addParticipantHTML = function () {
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

$('#addParticipant').on('click', function (e) {
  e.preventDefault();
  participantCt += 1;
  $(addParticipantHTML()).insertAfter($('.participant').last());
})


$('#deploy').on('click', function (e) {
  e.preventDefault();
  formData = $("form").serializeArray();
  // process form data
  var deployData = processFormData(formData);

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


function generateRicardianContract(_formData, _contractAddress) {
  var ricardianContract = new jsPDF();
  ricardianContract.setFontSize(40);
  ricardianContract.text(35, 25, "Octonyan loves jsPDF");
  ricardianContract.save('contract.pdf');
}
