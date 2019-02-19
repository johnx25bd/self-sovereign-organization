


// initialising absoluteVote
    // Set the voting parameters for the Absolute Vote Voting Machine – percentage and vote on behalf
await absoluteVote.setParameters(votePercentage, true);

// Voting parameters and schemes params:
var voteParametersHash = await absoluteVote.getParametersHash(
  votePercentage,
  true
  );
