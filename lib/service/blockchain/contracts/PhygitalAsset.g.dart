// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"bytes32","name":"merkleRootOfCollection_","type":"bytes32"},{"internalType":"bytes","name":"collectionJSONURL_","type":"bytes"},{"internalType":"string","name":"name_","type":"string"},{"internalType":"string","name":"symbol_","type":"string"},{"internalType":"bytes","name":"metadataJSONURL_","type":"bytes"},{"internalType":"bytes","name":"metadataBaseURI_","type":"bytes"},{"internalType":"address","name":"collectionOwner_","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"ERC725Y_DataKeysValuesEmptyArray","type":"error"},{"inputs":[],"name":"ERC725Y_DataKeysValuesLengthMismatch","type":"error"},{"inputs":[],"name":"ERC725Y_MsgValueDisallowed","type":"error"},{"inputs":[{"internalType":"bytes","name":"storedData","type":"bytes"}],"name":"InvalidExtensionAddress","type":"error"},{"inputs":[{"internalType":"bytes","name":"data","type":"bytes"}],"name":"InvalidFunctionSelector","type":"error"},{"inputs":[],"name":"LSP4TokenNameNotEditable","type":"error"},{"inputs":[],"name":"LSP4TokenSymbolNotEditable","type":"error"},{"inputs":[],"name":"LSP8CannotSendToAddressZero","type":"error"},{"inputs":[],"name":"LSP8CannotSendToSelf","type":"error"},{"inputs":[],"name":"LSP8CannotUseAddressZeroAsOperator","type":"error"},{"inputs":[],"name":"LSP8InvalidTransferBatch","type":"error"},{"inputs":[{"internalType":"bytes32","name":"tokenId","type":"bytes32"}],"name":"LSP8NonExistentTokenId","type":"error"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bytes32","name":"tokenId","type":"bytes32"}],"name":"LSP8NonExistingOperator","type":"error"},{"inputs":[{"internalType":"bytes32","name":"tokenId","type":"bytes32"},{"internalType":"address","name":"caller","type":"address"}],"name":"LSP8NotTokenOperator","type":"error"},{"inputs":[{"internalType":"address","name":"tokenOwner","type":"address"},{"internalType":"bytes32","name":"tokenId","type":"bytes32"},{"internalType":"address","name":"caller","type":"address"}],"name":"LSP8NotTokenOwner","type":"error"},{"inputs":[{"internalType":"address","name":"tokenReceiver","type":"address"}],"name":"LSP8NotifyTokenReceiverContractMissingLSP1Interface","type":"error"},{"inputs":[{"internalType":"address","name":"tokenReceiver","type":"address"}],"name":"LSP8NotifyTokenReceiverIsEOA","type":"error"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bytes32","name":"tokenId","type":"bytes32"}],"name":"LSP8OperatorAlreadyAuthorized","type":"error"},{"inputs":[],"name":"LSP8TokenContractCannotHoldValue","type":"error"},{"inputs":[{"internalType":"bytes32","name":"tokenId","type":"bytes32"}],"name":"LSP8TokenIdAlreadyMinted","type":"error"},{"inputs":[],"name":"LSP8TokenIdTypeNotEditable","type":"error"},{"inputs":[],"name":"LSP8TokenOwnerCannotBeOperator","type":"error"},{"inputs":[{"internalType":"bytes4","name":"functionSelector","type":"bytes4"}],"name":"NoExtensionFoundForFunctionSelector","type":"error"},{"inputs":[{"internalType":"address","name":"callerAddress","type":"address"}],"name":"OwnableCallerNotTheOwner","type":"error"},{"inputs":[],"name":"OwnableCannotSetZeroAddressAsOwner","type":"error"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"bytes32","name":"phygitalId","type":"bytes32"}],"name":"PhygitalAssetHasAlreadyAVerifiedOwnership","type":"error"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"bytes32","name":"phygitalId","type":"bytes32"}],"name":"PhygitalAssetHasAnUnverifiedOwnership","type":"error"},{"inputs":[{"internalType":"bytes32","name":"phygitalId","type":"bytes32"}],"name":"PhygitalAssetIsNotPartOfCollection","type":"error"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"bytes32","name":"phygitalId","type":"bytes32"}],"name":"PhygitalAssetOwnershipVerificationFailed","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"operator","type":"address"},{"indexed":true,"internalType":"address","name":"tokenOwner","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tokenId","type":"bytes32"},{"indexed":false,"internalType":"bytes","name":"operatorNotificationData","type":"bytes"}],"name":"AuthorizedOperator","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"dataKey","type":"bytes32"},{"indexed":false,"internalType":"bytes","name":"dataValue","type":"bytes"}],"name":"DataChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"operator","type":"address"},{"indexed":true,"internalType":"address","name":"tokenOwner","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tokenId","type":"bytes32"},{"indexed":false,"internalType":"bool","name":"notified","type":"bool"},{"indexed":false,"internalType":"bytes","name":"operatorNotificationData","type":"bytes"}],"name":"RevokedOperator","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"operator","type":"address"},{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tokenId","type":"bytes32"},{"indexed":false,"internalType":"bool","name":"force","type":"bool"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"}],"name":"Transfer","type":"event"},{"stateMutability":"payable","type":"fallback"},{"inputs":[{"internalType":"bytes32[]","name":"merkleProofOfCollection","type":"bytes32[]"},{"internalType":"bytes32","name":"phygitalId","type":"bytes32"}],"name":"_isPhygitalPartOfCollection","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"phygitalOwner","type":"address"},{"internalType":"bytes32","name":"phygitalId","type":"bytes32"},{"internalType":"bytes","name":"phygitalSignature","type":"bytes"}],"name":"_verifyPhygitalOwnership","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bytes32","name":"tokenId","type":"bytes32"},{"internalType":"bytes","name":"operatorNotificationData","type":"bytes"}],"name":"authorizeOperator","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"tokenOwner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"dataKey","type":"bytes32"}],"name":"getData","outputs":[{"internalType":"bytes","name":"dataValue","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32[]","name":"dataKeys","type":"bytes32[]"}],"name":"getDataBatch","outputs":[{"internalType":"bytes[]","name":"dataValues","type":"bytes[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"tokenId","type":"bytes32"}],"name":"getOperatorsOf","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bytes32","name":"tokenId","type":"bytes32"}],"name":"isOperatorFor","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"merkleRootOfCollection","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"phygitalAddress","type":"address"},{"internalType":"bytes","name":"phygitalSignature","type":"bytes"},{"internalType":"bytes32[]","name":"merkleProofOfCollection","type":"bytes32[]"},{"internalType":"bool","name":"force","type":"bool"}],"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"name":"nonce","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bytes32","name":"tokenId","type":"bytes32"},{"internalType":"bool","name":"notify","type":"bool"},{"internalType":"bytes","name":"operatorNotificationData","type":"bytes"}],"name":"revokeOperator","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"dataKey","type":"bytes32"},{"internalType":"bytes","name":"dataValue","type":"bytes"}],"name":"setData","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes32[]","name":"dataKeys","type":"bytes32[]"},{"internalType":"bytes[]","name":"dataValues","type":"bytes[]"}],"name":"setDataBatch","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenAt","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"tokenOwner","type":"address"}],"name":"tokenIdsOf","outputs":[{"internalType":"bytes32[]","name":"","type":"bytes32[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"tokenId","type":"bytes32"}],"name":"tokenOwnerOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"bytes32","name":"tokenId","type":"bytes32"},{"internalType":"bool","name":"force","type":"bool"},{"internalType":"bytes","name":"data","type":"bytes"}],"name":"transfer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"from","type":"address[]"},{"internalType":"address[]","name":"to","type":"address[]"},{"internalType":"bytes32[]","name":"tokenId","type":"bytes32[]"},{"internalType":"bool[]","name":"force","type":"bool[]"},{"internalType":"bytes[]","name":"data","type":"bytes[]"}],"name":"transferBatch","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"name":"verifiedOwnership","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"phygitalAddress","type":"address"},{"internalType":"bytes","name":"phygitalSignature","type":"bytes"}],"name":"verifyOwnershipAfterTransfer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"stateMutability":"payable","type":"receive"}]',
  'PhygitalAsset',
);

class PhygitalAsset extends _i1.GeneratedContract {
  PhygitalAsset({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> _isPhygitalPartOfCollection(
    List<_i2.Uint8List> merkleProofOfCollection,
    _i2.Uint8List phygitalId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'a20dd645'));
    final params = [
      merkleProofOfCollection,
      phygitalId,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> _verifyPhygitalOwnership(
    _i1.EthereumAddress phygitalOwner,
    _i2.Uint8List phygitalId,
    _i2.Uint8List phygitalSignature, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'fa8dc234'));
    final params = [
      phygitalOwner,
      phygitalId,
      phygitalSignature,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> authorizeOperator(
    _i1.EthereumAddress operator,
    _i2.Uint8List tokenId,
    _i2.Uint8List operatorNotificationData, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '86a10ddd'));
    final params = [
      operator,
      tokenId,
      operatorNotificationData,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> balanceOf(
    _i1.EthereumAddress tokenOwner, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '70a08231'));
    final params = [tokenOwner];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> getData(
    _i2.Uint8List dataKey, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '54f6127f'));
    final params = [dataKey];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i2.Uint8List>> getDataBatch(
    List<_i2.Uint8List> dataKeys, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, 'dedff9c6'));
    final params = [dataKeys];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i2.Uint8List>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i1.EthereumAddress>> getOperatorsOf(
    _i2.Uint8List tokenId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '49a6078d'));
    final params = [tokenId];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i1.EthereumAddress>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> isOperatorFor(
    _i1.EthereumAddress operator,
    _i2.Uint8List tokenId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '2a3654a4'));
    final params = [
      operator,
      tokenId,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> merkleRootOfCollection({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, '07c79bb2'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> mint(
    _i1.EthereumAddress phygitalAddress,
    _i2.Uint8List phygitalSignature,
    List<_i2.Uint8List> merkleProofOfCollection,
    bool force, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '31646613'));
    final params = [
      phygitalAddress,
      phygitalSignature,
      merkleProofOfCollection,
      force,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> nonce(
    _i2.Uint8List $param18, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, '905da30f'));
    final params = [$param18];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> owner({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '8da5cb5b'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> renounceOwnership({
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, '715018a6'));
    final params = [];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> revokeOperator(
    _i1.EthereumAddress operator,
    _i2.Uint8List tokenId,
    bool notify,
    _i2.Uint8List operatorNotificationData, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[15];
    assert(checkSignature(function, 'db8c9663'));
    final params = [
      operator,
      tokenId,
      notify,
      operatorNotificationData,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setData(
    _i2.Uint8List dataKey,
    _i2.Uint8List dataValue, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[16];
    assert(checkSignature(function, '7f23690c'));
    final params = [
      dataKey,
      dataValue,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setDataBatch(
    List<_i2.Uint8List> dataKeys,
    List<_i2.Uint8List> dataValues, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[17];
    assert(checkSignature(function, '97902421'));
    final params = [
      dataKeys,
      dataValues,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> supportsInterface(
    _i2.Uint8List interfaceId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, '01ffc9a7'));
    final params = [interfaceId];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> tokenAt(
    BigInt index, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, '92a91a3a'));
    final params = [index];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i2.Uint8List>> tokenIdsOf(
    _i1.EthereumAddress tokenOwner, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[20];
    assert(checkSignature(function, 'a3b261f2'));
    final params = [tokenOwner];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i2.Uint8List>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> tokenOwnerOf(
    _i2.Uint8List tokenId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[21];
    assert(checkSignature(function, '217b2270'));
    final params = [tokenId];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> totalSupply({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[22];
    assert(checkSignature(function, '18160ddd'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transfer(
    _i1.EthereumAddress from,
    _i1.EthereumAddress to,
    _i2.Uint8List tokenId,
    bool force,
    _i2.Uint8List data, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[23];
    assert(checkSignature(function, '511b6952'));
    final params = [
      from,
      to,
      tokenId,
      force,
      data,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transferBatch(
    List<_i1.EthereumAddress> from,
    List<_i1.EthereumAddress> to,
    List<_i2.Uint8List> tokenId,
    List<bool> force,
    List<_i2.Uint8List> data, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[24];
    assert(checkSignature(function, '7e87632c'));
    final params = [
      from,
      to,
      tokenId,
      force,
      data,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transferOwnership(
    _i1.EthereumAddress newOwner, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[25];
    assert(checkSignature(function, 'f2fde38b'));
    final params = [newOwner];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> verifiedOwnership(
    _i2.Uint8List $param42, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[26];
    assert(checkSignature(function, '4d55c5a4'));
    final params = [$param42];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> verifyOwnershipAfterTransfer(
    _i1.EthereumAddress phygitalAddress,
    _i2.Uint8List phygitalSignature, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[27];
    assert(checkSignature(function, '41b3d513'));
    final params = [
      phygitalAddress,
      phygitalSignature,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all AuthorizedOperator events emitted by this contract.
  Stream<AuthorizedOperator> authorizedOperatorEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('AuthorizedOperator');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return AuthorizedOperator(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all DataChanged events emitted by this contract.
  Stream<DataChanged> dataChangedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('DataChanged');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return DataChanged(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all OwnershipTransferred events emitted by this contract.
  Stream<OwnershipTransferred> ownershipTransferredEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OwnershipTransferred');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OwnershipTransferred(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all RevokedOperator events emitted by this contract.
  Stream<RevokedOperator> revokedOperatorEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('RevokedOperator');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return RevokedOperator(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all Transfer events emitted by this contract.
  Stream<Transfer> transferEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Transfer');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Transfer(
        decoded,
        result,
      );
    });
  }
}

class AuthorizedOperator {
  AuthorizedOperator(
    List<dynamic> response,
    this.event,
  )   : operator = (response[0] as _i1.EthereumAddress),
        tokenOwner = (response[1] as _i1.EthereumAddress),
        tokenId = (response[2] as _i2.Uint8List),
        operatorNotificationData = (response[3] as _i2.Uint8List);

  final _i1.EthereumAddress operator;

  final _i1.EthereumAddress tokenOwner;

  final _i2.Uint8List tokenId;

  final _i2.Uint8List operatorNotificationData;

  final _i1.FilterEvent event;
}

class DataChanged {
  DataChanged(
    List<dynamic> response,
    this.event,
  )   : dataKey = (response[0] as _i2.Uint8List),
        dataValue = (response[1] as _i2.Uint8List);

  final _i2.Uint8List dataKey;

  final _i2.Uint8List dataValue;

  final _i1.FilterEvent event;
}

class OwnershipTransferred {
  OwnershipTransferred(
    List<dynamic> response,
    this.event,
  )   : previousOwner = (response[0] as _i1.EthereumAddress),
        newOwner = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress previousOwner;

  final _i1.EthereumAddress newOwner;

  final _i1.FilterEvent event;
}

class RevokedOperator {
  RevokedOperator(
    List<dynamic> response,
    this.event,
  )   : operator = (response[0] as _i1.EthereumAddress),
        tokenOwner = (response[1] as _i1.EthereumAddress),
        tokenId = (response[2] as _i2.Uint8List),
        notified = (response[3] as bool),
        operatorNotificationData = (response[4] as _i2.Uint8List);

  final _i1.EthereumAddress operator;

  final _i1.EthereumAddress tokenOwner;

  final _i2.Uint8List tokenId;

  final bool notified;

  final _i2.Uint8List operatorNotificationData;

  final _i1.FilterEvent event;
}

class Transfer {
  Transfer(
    List<dynamic> response,
    this.event,
  )   : operator = (response[0] as _i1.EthereumAddress),
        from = (response[1] as _i1.EthereumAddress),
        to = (response[2] as _i1.EthereumAddress),
        tokenId = (response[3] as _i2.Uint8List),
        force = (response[4] as bool),
        data = (response[5] as _i2.Uint8List);

  final _i1.EthereumAddress operator;

  final _i1.EthereumAddress from;

  final _i1.EthereumAddress to;

  final _i2.Uint8List tokenId;

  final bool force;

  final _i2.Uint8List data;

  final _i1.FilterEvent event;
}
