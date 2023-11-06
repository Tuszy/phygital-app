# Phygital App

Mobile application for creating, minting and verifying phygitals.

## Phygital Asset Creation - Workflow

1. Open the [Frontend](https://github.com/Tuszy/phygital-frontend) - [https://phygital.tuszy.com](https://phygital.tuszy.com)
   1. Click the **Add 'Create Phygital Asset' Permission** button
   2. Add the requested permission to your Universal Profile by using the [🆙 Extension](https://docs.lukso.tech/install-up-browser-extension/)
2. Flash an arbitrary amount of [Phygital NFC Tags](https://github.com/Tuszy/phygital-nfc-tag) with the provided [Phygital Firmware](https://github.com/Tuszy/phygital-nfc-tag/tree/main/arduino-code)
   1. On the first boot an asymmetric secp256k1 key-pair is generated, identifying the phygital in a unique way and allowing it to sign messages to verify the ownership (e.g. for minting and transferring)
3. [Download](https://phygital-app.tuszy.com) and open the [Phygital-App](https://github.com/Tuszy/phygital-app)
   1. Input your **Universal Profile Address** (or scan QR code shown in [Frontend](https://github.com/Tuszy/phygital-frontend)) and click the **Confirm** button
      1. App checks if the previously requested permission is set.
         1. YES: App proceeds
         2. NO: Error message appears
   2. Click the **Create Phygital Asset** button
      1. App opens **Create Phygital Asset** screen
   3. Input the *Name*, *Symbol* and *Metadata* (images, descriptions, links etc.) using the given form
   4. For each flashed [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag):
      1. Click the **Add Phygital** button
      2. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
         1. Reads the *public key* from the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag), hashes it to get the *Phygital id* and adds it to the list
   5. Click on the **Deploy** button and wait until the deployment steps are completed:
      1. App creates LSP4 metadata from input
      2. App uploads LSP4 metadata to IPFS
      3. App uploads the list of phygital ids (collection) to IPFS
      4. App sends needed data to [Backend](https://github.com/Tuszy/phygital-backend) 
         1. [Backend](https://github.com/Tuszy/phygital-backend) deploys *Phygital Asset* contract instance with controller key
   6. App opens **Assign Phygital to Collection** screen 
   7. For each flashed [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag)
      1. Click the **Assign Phygital to Collection** button
      2. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
         1. Writes the address of the deployed contract to the NFC tag (bidirectional binding)
   8. Click on the **Done** button
   9. App returns to **Home** screen
   10. **Phygital Asset Creation** done



## Phygital Asset Minting - Workflow

1. Open the [Frontend](https://github.com/Tuszy/phygital-frontend) - [https://phygital.tuszy.com](https://phygital.tuszy.com)
   1. Click the **Add 'Mint Phygital' Permission** button
   2. Add the requested permission to your Universal Profile by using the [🆙 Extension](https://docs.lukso.tech/install-up-browser-extension/)
2. [Download](https://phygital-app.tuszy.com) and open the [Phygital-App](https://github.com/Tuszy/phygital-app)
   1. Input your **Universal Profile Address** (or scan QR code shown in [Frontend](https://github.com/Tuszy/phygital-frontend)) and click the **Confirm** button
      1. App checks if the previously requested permission is set.
         1. YES: App proceeds
         2. NO: Error message appears
   2. Click the **Mint Phygital** button
      1. App opens **Mint Phygital** screen
      2. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
         1. Checks if the phygital has not been minted yet
            1. YES: App proceeds
            2. NO: Error message appears and exits **Mint Phygital** screen
         2. Click on the **Mint** button and wait until the minting steps are completed:
            1. [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) signs **Universal Profile Address** with internal *private key* and returns the signature
            2. App reads *public key* from [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) and hashes it to get **Phygital id**
            3. App fetches list of phygital ids (collection) from IPFS:
               1. Determines *phygital index*
               2. Calculates *merkle proof*
            4. App sends needed data to [Backend](https://github.com/Tuszy/phygital-backend) 
               1. [Backend](https://github.com/Tuszy/phygital-backend) calls *mint* contract function with controller key
   3. App returns to **Home** screen
   4. *Phygital Asset Minting* done
   
## Phygital Asset Ownership Verification after Transfer - Workflow

1. Open the [Frontend](https://github.com/Tuszy/phygital-frontend) - [https://phygital.tuszy.com](https://phygital.tuszy.com)
   1. Click the **Add 'Verify Phygital Ownership' Permission** button
   2. Add the requested permission to your Universal Profile by using the [🆙 Extension](https://docs.lukso.tech/install-up-browser-extension/)
2. [Download](https://phygital-app.tuszy.com) and open the [Phygital-App](https://github.com/Tuszy/phygital-app)
   1. Input your **Universal Profile Address** (or scan QR code shown in [Frontend](https://github.com/Tuszy/phygital-frontend)) and click the **Confirm** button
      1. App checks if the previously requested permission is set.
         1. YES: App proceeds
         2. NO: Error message appears
   2. Click the **Verify Phygital Ownership** button
      1. App opens **Verify Phygital Ownership** screen
      2. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
         1. Checks if the phygital has been transferred to the given *Universal Profile Address*
            1. YES: App proceeds
            2. NO: Error message appears and exits **Mint Phygital** screen
         2. Click on the **Verify Ownership** button and wait until the ownership verification steps are completed:
            1. [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) signs **Universal Profile Address** with internal *private key* and returns the signature
            2. App reads *public key* from [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) and hashes it to get **Phygital id**
            3. App sends needed data to [Backend](https://github.com/Tuszy/phygital-backend) 
               1. [Backend](https://github.com/Tuszy/phygital-backend)  calls *verifyOwnershipAfterTransfer* contract function with controller key
   3. App returns to **Home** screen
   4. *Phygital Asset Ownership Verification after Transfer* done

## Terminology
- Phygital Address: public key of the NFC tag
- Phygital Id: hashed public key of the NFC tag