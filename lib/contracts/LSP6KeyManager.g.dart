// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"address","name":"target_","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"BatchExecuteParamsLengthMismatch","type":"error"},{"inputs":[],"name":"BatchExecuteRelayCallParamsLengthMismatch","type":"error"},{"inputs":[],"name":"CallingKeyManagerNotAllowed","type":"error"},{"inputs":[],"name":"DelegateCallDisallowedViaKeyManager","type":"error"},{"inputs":[],"name":"ERC725X_ExecuteParametersEmptyArray","type":"error"},{"inputs":[],"name":"ERC725X_ExecuteParametersLengthMismatch","type":"error"},{"inputs":[],"name":"ERC725Y_DataKeysValuesLengthMismatch","type":"error"},{"inputs":[{"internalType":"bytes32","name":"dataKey","type":"bytes32"},{"internalType":"bytes","name":"dataValue","type":"bytes"}],"name":"InvalidDataValuesForDataKeys","type":"error"},{"inputs":[{"internalType":"bytes4","name":"invalidFunction","type":"bytes4"}],"name":"InvalidERC725Function","type":"error"},{"inputs":[{"internalType":"bytes","name":"allowedCallsValue","type":"bytes"}],"name":"InvalidEncodedAllowedCalls","type":"error"},{"inputs":[{"internalType":"bytes","name":"value","type":"bytes"},{"internalType":"string","name":"context","type":"string"}],"name":"InvalidEncodedAllowedERC725YDataKeys","type":"error"},{"inputs":[],"name":"InvalidLSP6Target","type":"error"},{"inputs":[{"internalType":"bytes","name":"payload","type":"bytes"}],"name":"InvalidPayload","type":"error"},{"inputs":[{"internalType":"address","name":"signer","type":"address"},{"internalType":"uint256","name":"invalidNonce","type":"uint256"},{"internalType":"bytes","name":"signature","type":"bytes"}],"name":"InvalidRelayNonce","type":"error"},{"inputs":[{"internalType":"address","name":"from","type":"address"}],"name":"InvalidWhitelistedCall","type":"error"},{"inputs":[],"name":"KeyManagerCannotBeSetAsExtensionForLSP20Functions","type":"error"},{"inputs":[{"internalType":"uint256","name":"totalValues","type":"uint256"},{"internalType":"uint256","name":"msgValue","type":"uint256"}],"name":"LSP6BatchExcessiveValueSent","type":"error"},{"inputs":[{"internalType":"uint256","name":"totalValues","type":"uint256"},{"internalType":"uint256","name":"msgValue","type":"uint256"}],"name":"LSP6BatchInsufficientValueSent","type":"error"},{"inputs":[{"internalType":"address","name":"from","type":"address"}],"name":"NoCallsAllowed","type":"error"},{"inputs":[{"internalType":"address","name":"from","type":"address"}],"name":"NoERC725YDataKeysAllowed","type":"error"},{"inputs":[{"internalType":"address","name":"from","type":"address"}],"name":"NoPermissionsSet","type":"error"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"bytes4","name":"selector","type":"bytes4"}],"name":"NotAllowedCall","type":"error"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"bytes32","name":"disallowedKey","type":"bytes32"}],"name":"NotAllowedERC725YDataKey","type":"error"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"string","name":"permission","type":"string"}],"name":"NotAuthorised","type":"error"},{"inputs":[{"internalType":"bytes32","name":"dataKey","type":"bytes32"}],"name":"NotRecognisedPermissionKey","type":"error"},{"inputs":[],"name":"RelayCallBeforeStartTime","type":"error"},{"inputs":[],"name":"RelayCallExpired","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"signer","type":"address"},{"indexed":true,"internalType":"uint256","name":"value","type":"uint256"},{"indexed":true,"internalType":"bytes4","name":"selector","type":"bytes4"}],"name":"PermissionsVerified","type":"event"},{"inputs":[],"name":"VERSION","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes","name":"payload","type":"bytes"}],"name":"execute","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"values","type":"uint256[]"},{"internalType":"bytes[]","name":"payloads","type":"bytes[]"}],"name":"executeBatch","outputs":[{"internalType":"bytes[]","name":"","type":"bytes[]"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes","name":"signature","type":"bytes"},{"internalType":"uint256","name":"nonce","type":"uint256"},{"internalType":"uint256","name":"validityTimestamps","type":"uint256"},{"internalType":"bytes","name":"payload","type":"bytes"}],"name":"executeRelayCall","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes[]","name":"signatures","type":"bytes[]"},{"internalType":"uint256[]","name":"nonces","type":"uint256[]"},{"internalType":"uint256[]","name":"validityTimestamps","type":"uint256[]"},{"internalType":"uint256[]","name":"values","type":"uint256[]"},{"internalType":"bytes[]","name":"payloads","type":"bytes[]"}],"name":"executeRelayCallBatch","outputs":[{"internalType":"bytes[]","name":"","type":"bytes[]"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"uint128","name":"channelId","type":"uint128"}],"name":"getNonce","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"dataHash","type":"bytes32"},{"internalType":"bytes","name":"signature","type":"bytes"}],"name":"isValidSignature","outputs":[{"internalType":"bytes4","name":"returnedStatus","type":"bytes4"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"targetContract","type":"address"},{"internalType":"address","name":"caller","type":"address"},{"internalType":"uint256","name":"msgValue","type":"uint256"},{"internalType":"bytes","name":"callData","type":"bytes"}],"name":"lsp20VerifyCall","outputs":[{"internalType":"bytes4","name":"","type":"bytes4"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"},{"internalType":"bytes","name":"","type":"bytes"}],"name":"lsp20VerifyCallResult","outputs":[{"internalType":"bytes4","name":"","type":"bytes4"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"target","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"}]',
  'LSP6KeyManager',
);

class LSP6KeyManager extends _i1.GeneratedContract {
  LSP6KeyManager({
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
  Future<String> VERSION({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'ffa1ad74'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as String);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> execute(
    _i2.Uint8List payload, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '09c5eabe'));
    final params = [payload];
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
  Future<String> executeBatch(
    List<BigInt> values,
    List<_i2.Uint8List> payloads, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'bf0176ff'));
    final params = [
      values,
      payloads,
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
  Future<String> executeRelayCall(
    _i2.Uint8List signature,
    BigInt nonce,
    BigInt validityTimestamps,
    _i2.Uint8List payload, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '4c8a4e74'));
    final params = [
      signature,
      nonce,
      validityTimestamps,
      payload,
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
  Future<String> executeRelayCallBatch(
    List<_i2.Uint8List> signatures,
    List<BigInt> nonces,
    List<BigInt> validityTimestamps,
    List<BigInt> values,
    List<_i2.Uint8List> payloads, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'a20856a5'));
    final params = [
      signatures,
      nonces,
      validityTimestamps,
      values,
      payloads,
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
  Future<BigInt> getNonce(
    _i1.EthereumAddress from,
    BigInt channelId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'b44581d9'));
    final params = [
      from,
      channelId,
    ];
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
  Future<_i2.Uint8List> isValidSignature(
    _i2.Uint8List dataHash,
    _i2.Uint8List signature, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '1626ba7e'));
    final params = [
      dataHash,
      signature,
    ];
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
  Future<bool> supportsInterface(
    _i2.Uint8List interfaceId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[10];
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
  Future<_i1.EthereumAddress> target({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, 'd4b83992'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// Returns a live stream of all PermissionsVerified events emitted by this contract.
  Stream<PermissionsVerified> permissionsVerifiedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('PermissionsVerified');
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
      return PermissionsVerified(
        decoded,
        result,
      );
    });
  }
}

class PermissionsVerified {
  PermissionsVerified(
    List<dynamic> response,
    this.event,
  )   : signer = (response[0] as _i1.EthereumAddress),
        value = (response[1] as BigInt),
        selector = (response[2] as _i2.Uint8List);

  final _i1.EthereumAddress signer;

  final BigInt value;

  final _i2.Uint8List selector;

  final _i1.FilterEvent event;
}
