pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./Project.sol";

contract ProjectFactory {
  using SafeMath for uint;

  uint projectNum;
  Project[] public projects;

  struct Participant {
    address ethAddress;
    string legalName;
    string githubUsername;
    uint owes;
    bool initialized;
    // uint equityUnique;
    // self sovereign ID ?
  }

  constructor () public {

  }

  event projectCreated (uint projectContractAddress_);

  function createProject (
    string memory _githubRepo,
    address _adminRole,
    string memory _adminName,
    string memory _adminGithubUsername,
    string memory _purpose,
    address _voteInterface,
    uint _votePercentage )
  public returns
    (uint)
  {

    Project newProject = new Project(
      _githubRepo,
      _adminRole,
       _adminName,
       _adminGithubUsername,
       _purpose,
       _voteInterface,
       _votePercentage,
       projectNum);

    projects.push(newProject);
    projectNum = projectNum + 1;

    emit projectCreated(100);

    return projectNum;

  }

}
