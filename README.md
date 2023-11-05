# Phygital App

Mobile application for creating, minting and verifying phygitals.

## Phygital Asset Creation - Workflow

1. Open the [Frontend](https://github.com/Tuszy/phygital-frontend) - [https://phygital.tuszy.com](https://phygital.tuszy.com)
   1. Click the **Add 'Create Phygital Collection' Permission** button
   2. Add the requested permission to your Universal Profile by using the [🆙 Extension](https://docs.lukso.tech/install-up-browser-extension/)
2. Flash an arbitrary amount of [Phygital NFC Tags](https://github.com/Tuszy/phygital-nfc-tag) with the provided [Phygital Firmware](https://github.com/Tuszy/phygital-nfc-tag/tree/main/arduino-code)
   1. On the first boot an asymmetric secp256k1 key-pair is generated, identifying the phygital in a unique way and allowing it to sign messages to verify the ownership (e.g. for minting and transferring)
3. Open the [Phygital-App](https://github.com/Tuszy/phygital-app)
   1. Input your **Universal Profile Address** and click the **Confirm** button
      1. App checks if the previously requested permission is set.
         1. YES: App proceeds
         2. NO: Error message appears
   2. Click the **Create Phygital Collection** button
      1. App opens **Create Phygital Collection** screen
   3. Input the *Name*, *Symbol* and *Metadata* (images, descriptions, links etc.) using the given form
   4. For each flashed [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag):
      1. Click the **Add Phygital** button
      2. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
         1. Reads the *Phygital id* from the NFC tag and adds it to the list
   5. Click on the **Deploy** button and wait until the deployment steps are completed:
      1. Creates LSP4 metadata from input
      2. Uploads LSP4 metadata to IPFS
      3. Creates a merkle tree using the list of phygital ids
      4. Uploads merkle tree to IPFS
      5. Deploys *Phygital Asset* contract instance
   6. For each flashed [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag)
      1. Click the **Assign Phygital to Collection** button
      2. Scan the [Phygital NFC Tag](https://github.com/Tuszy/phygital-nfc-tag) 
         1. Writes the address of the deployed contract to the NFC tag (bidirectional binding)
   

## Terminology
- Phygital Address: public key of the NFC tag
- Phygital Id: hashed public key of the NFC tag