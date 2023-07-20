enum SigningStatus {
  SIGNING_SESSION_CREATED, // Signing information is created but information that is required for signing has not been populated yet
  SIGNING_IN_PROGRESS, // Signing is in progress by parties
  SIGNING_COMPLETED, // All required parties has signed but not broadcasted yet
  SIGNING_FAILED, // Signing failed or signed but failed on broadcast
  SIGNING_BROADCASTED // transaction has been broadcasted to network. Transaction may not included in a block
}

