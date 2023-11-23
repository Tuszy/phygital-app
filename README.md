# Phygital App

Mobile application for creating, transferring, minting and verifying phygitals.

# Remarks
Due to the tight schedule, I wasn't able to upload the app to the *App Store* nor *App Store Connect*. But even if I were able to upload the app, it wouldn't make a lot of sense downloading it as you wouldn't be able to do more than just log in as you would need the [Phygital NFC Tags](https://github.com/Tuszy/phygital-nfc-tag) to play around with it. Because of this reason I have created a bunch of videos of all the possible scenarios that may come up during its usage.

# Dev Tools
1. [Flutter](https://flutter.dev/)
   1. App has been developed and tested on an iOS mobile (iPhone 13 mini), but should theoretically work on Android aswell
   2.  Attention: Due to time restrictions I have neglected to test it on Android and any other screen resolutions.
2. [Android Studio](https://developer.android.com/studio)
3. [XCode](https://developer.apple.com/xcode/)

## Login - Workflow
1. Open the [Frontend](https://github.com/Tuszy/phygital-frontend)
   1. Press the **LOGIN WITH UNIVERSAL PROFILE** button
   2. Select a **Universal Profile**
   3. Press the **SET PERMISSIONS** button (if not done before)
      1. Confirm the transaction to set the necessary permissions for the controller key used by the [Backend](https://github.com/Tuszy/phygital-backend)
      2. Wait until the transaction is completed
   4. Press the **CREATE APP LOGIN QR CODE** button
      1. Press the **Log in** button in the UP extension to confirm the login (sends request to the [Backend](https://github.com/Tuszy/phygital-backend) which returns a Json Web Token that is valid for 24 hours)
      2. **App Login QR Code** is shown (contains universal profile address, chain id and json web token for authentication)
2. Open the [Phygital-App](https://github.com/Tuszy/phygital-app)
   1. Press the **Login with Universal Profile** button
   2. Scan the **App Login QR Code**
      1. App checks if the login code is valid.
         1. YES: App logs you in
         2. NO: Error message appears

## Phygital Asset Creation - Workflow
1. Flash an arbitrary amount of [Phygital NFC Tags](https://github.com/Tuszy/phygital-nfc-tag) with the provided [Phygital Firmware](https://github.com/Tuszy/phygital-nfc-tag/tree/main/arduino-code)
   1. On the first boot an asymmetric secp256k1 key-pair is generated, identifying the phygital in a unique way and allowing it to sign messages to verify the ownership (e.g. for minting and transferring)
2. Open the [Phygital-App](https://github.com/Tuszy/phygital-app)
3. Login if necessary ([see Login - Workflow](#login---workflow))
4. Press the **Menu** button
5. Press the **Create** button
6. App opens **Create Collection** screen
7. Input the *Name*, *Symbol* and *Metadata* (images, descriptions, links etc.) for the collection using the given form
8. For each flashed [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag):
   1. Press the **Add** button in the *Phygitals* section
   2. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
       1. Reads the *public key* from the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag)
   3. Input the *Name*, *Symbol* and *Metadata* (images, descriptions, links etc.) for the phygital using the given form
9. Press the **Create** button and wait until the deployment steps are completed:
   1. App creates LSP4 metadata for collection and phygitals
   2. App uploads LSP4 metadata to IPFS
   3. App uploads images for collection and phygitals to IPFS
   4. App uploads the list of phygital addresses (collection) to IPFS
   5. App sends needed data to [Backend](https://github.com/Tuszy/phygital-backend) 
      1. [Backend](https://github.com/Tuszy/phygital-backend) deploys *Phygital Asset* contract instance with controller key
10. App opens **Assign Collection** screen 
11. For each flashed [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag)
    1. Press the **Assign** button in the *Left Phygitals* section
    2. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
    3. Writes the address of the deployed contract to the NFC tag (bidirectional binding)
12. Once all [Phygital NFC Tags](https://github.com/Tuszy/phygital-nfc-tag) have been assigned the collection
    1.  App opens the **Phygital Collection** screen
13.   **Phygital Asset Creation** done



## Phygital Asset Minting - Workflow

1. Open the [Phygital-App](https://github.com/Tuszy/phygital-app)
2. Login if necessary ([see Login - Workflow](#login---workflow))
3. Press the **Menu** button
4. Press the **Mint** button
5. App prompts you to scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
6. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
      1. App reads phygital data and checks if it is valid
         1. NOT MINTED: App opens **Phygital** screen with **Mint** button
         2. MINTED/UNASSIGNED/INVALID: Error message appears
7. Press the **Mint** button
8. App prompts you to scan the same [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) to start minting
9. Wait until the minting steps are completed:
   1. [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) signs **Universal Profile Address** concatenated with the **Nonce 0** with internal *private key* and returns the signature
   2. App sends needed data to [Backend](https://github.com/Tuszy/phygital-backend) 
      1. [Backend](https://github.com/Tuszy/phygital-backend) calls *mint* contract function with controller key
10. App opens the **Phygital** screen
11. *Phygital Asset Minting* done
   
## Phygital Asset Transfer - Workflow
1. Open the [Phygital-App](https://github.com/Tuszy/phygital-app)
2. Login if necessary ([see Login - Workflow](#login---workflow))
3. Press the **Menu** button
4. Press the **Transfer** button
5. App prompts you to scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
6. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
      1. App reads phygital data and checks if it is valid
         1. LOGGED IN UP IS OWNER, MINTED AND VERIFIED OWNERSHIP: App opens **Phygital** screen with **Transfer** button
         2. UNMINTED/UNVERIFIED OWNERSHIP/NOT OWNER/UNASSIGNED/INVALID: Error message appears
7. Press the **Transfer** button
8. App prompts you to scan the QR code of the recipient's universal profile address
   1. VALID UP ADDRESS: App opens **To Universal Profile** screen with **Confirm** button
   1. INVALID UP ADDRESS: Error message appears
9. Press **Confirm** button
10. App prompts you to scan the same [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) to start the transfer
11. Wait until the transfer steps are completed:
   1. [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) signs **To Universal Profile Address** concatenated with the **current Nonce** retrieved from the collection's smart contract with internal *private key* and returns the signature
   2. App sends needed data to [Backend](https://github.com/Tuszy/phygital-backend) 
      1. [Backend](https://github.com/Tuszy/phygital-backend) calls *transfer* contract function with controller key
12. App opens the **Phygital** screen
13. *Phygital Asset Transfer* done


## Phygital Asset Ownership Verification after Transfer - Workflow
1. Open the [Phygital-App](https://github.com/Tuszy/phygital-app)
2. Login if necessary ([see Login - Workflow](#login---workflow))
3. Press the **Menu** button
4. Press the **Verify Ownership After Transfer** button
5. App prompts you to scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
6. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
      1. App reads phygital data and checks if it is valid
         1. LOGGED IN UP IS OWNER, MINTED AND UNVERIFIED OWNERSHIP: App opens **Phygital** screen with **Verify Ownership** button
         2. UNMINTED/VERIFIED OWNERSHIP/NOT OWNER/UNASSIGNED/INVALID: Error message appears
7. Press the **Verify Ownership** button
8. App prompts you to scan the same [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) to start verifying the ownership
9. Wait until the verification steps are completed:
   1. [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) signs **Universal Profile Address** concatenated with the **current Nonce** retrieved from the collection's smart contract with internal *private key* and returns the signature
   2. App sends needed data to [Backend](https://github.com/Tuszy/phygital-backend) 
      1. [Backend](https://github.com/Tuszy/phygital-backend) calls *verifyOwnershipAfterTransfer* contract function with controller key
10. App opens the **Phygital** screen
11. *Phygital Asset Ownership Verification after Transfer* done
