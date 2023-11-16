enum Result {
  success,

  invalidPhygital,

  invalidUniversalProfileAddress,
  invalidReceivingUniversalProfileAddress,
  invalidPhygitalAssetContractAddress,

  necessaryPermissionsNotSet,

  mintSucceeded,
  alreadyMinted,
  notPartOfCollection,
  notPartOfAnyCollection,
  signingFailed,
  mintFailed,

  ownershipVerificationSucceeded,
  notMintedYet,
  ownershipVerificationFailed,

  invalidOwnership,
  unverifiedOwnership,
  alreadyVerifiedOwnership,

  transferSucceeded,
  transferFailed,

  notInitialized,
  unknownError
}

String getMessageForResult(Result result){
  switch(result){
    case Result.success: return "Success.";

    case Result.invalidPhygital: return "Invalid Phygital.";

    case Result.invalidUniversalProfileAddress: return "Invalid Universal Profile.";
    case Result.invalidReceivingUniversalProfileAddress: return "Invalid receiving Universal Profile.";
    case Result.invalidPhygitalAssetContractAddress: return "Invalid Phygital collection.\nPlease check the contract address.";

    case Result.necessaryPermissionsNotSet: return "Please set the necessary permissions on the Universal profile.";

    case Result.mintSucceeded: return "Successfully minted Phygital.";
    case Result.alreadyMinted: return "Phygital has already been minted.";
    case Result.notPartOfCollection: return "Phygital is not part of the set collection.\nPlease check the contract address.";
    case Result.notPartOfAnyCollection: return "Phygital is not part of any collection.\nNo contract address found.";
    case Result.signingFailed: return "Creating phygital signature failed.\nTry again.";
    case Result.mintFailed: return "Minting failed.\nTry again.";

    case Result.ownershipVerificationSucceeded: return "Successfully verified Phygital ownership.";
    case Result.notMintedYet: return "Phygital has not been minted yet.";
    case Result.ownershipVerificationFailed: return "Ownership verification failed.\nTry again.";

    case Result.invalidOwnership: return "You are not the current owner of the Phygital.";
    case Result.unverifiedOwnership: return "Phygital has an unverified ownership. Please verify first.";
    case Result.alreadyVerifiedOwnership: return "Phygital ownership is already verified.";


    case Result.transferSucceeded: return "Successfully transferred the Phygital.";
    case Result.transferFailed: return "Failed to transfer the Phygital.\nTry again.";

    case Result.notInitialized: return "Lukso Client not initialized.\nRestart the app.";
    case Result.unknownError: return "Unknown error occurred.\nTry again.";
  }
}

Result mapContractErrorCodeToResult(String contractErrorCode) {
  switch(contractErrorCode){
    case "PhygitalAssetOwnershipVerificationFailed": return Result.ownershipVerificationFailed;
    case "PhygitalAssetIsNotPartOfCollection": return Result.notPartOfCollection;
    case "PhygitalAssetHasAnUnverifiedOwnership": return Result.unverifiedOwnership;
    case "PhygitalAssetHasAlreadyAVerifiedOwnership": return Result.alreadyVerifiedOwnership;
    case "LSP8NotTokenOwner": return Result.invalidOwnership;
    case "LSP8NotifyTokenReceiverIsEOA": return Result.invalidReceivingUniversalProfileAddress;
    case "LSP8TokenIdAlreadyMinted": return Result.alreadyMinted;
    default: return Result.unknownError;
  }
}