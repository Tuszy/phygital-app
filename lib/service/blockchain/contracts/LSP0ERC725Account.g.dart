// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"address","name":"initialOwner","type":"address"}],"stateMutability":"payable","type":"constructor"},{"inputs":[],"name":"ERC725X_ContractDeploymentFailed","type":"error"},{"inputs":[],"name":"ERC725X_CreateOperationsRequireEmptyRecipientAddress","type":"error"},{"inputs":[],"name":"ERC725X_ExecuteParametersEmptyArray","type":"error"},{"inputs":[],"name":"ERC725X_ExecuteParametersLengthMismatch","type":"error"},{"inputs":[{"internalType":"uint256","name":"balance","type":"uint256"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"ERC725X_InsufficientBalance","type":"error"},{"inputs":[],"name":"ERC725X_MsgValueDisallowedInDelegateCall","type":"error"},{"inputs":[],"name":"ERC725X_MsgValueDisallowedInStaticCall","type":"error"},{"inputs":[],"name":"ERC725X_NoContractBytecodeProvided","type":"error"},{"inputs":[{"internalType":"uint256","name":"operationTypeProvided","type":"uint256"}],"name":"ERC725X_UnknownOperationType","type":"error"},{"inputs":[],"name":"ERC725Y_DataKeysValuesEmptyArray","type":"error"},{"inputs":[],"name":"ERC725Y_DataKeysValuesLengthMismatch","type":"error"},{"inputs":[{"internalType":"address","name":"caller","type":"address"}],"name":"LSP14CallerNotPendingOwner","type":"error"},{"inputs":[],"name":"LSP14CannotTransferOwnershipToSelf","type":"error"},{"inputs":[],"name":"LSP14MustAcceptOwnershipInSeparateTransaction","type":"error"},{"inputs":[{"internalType":"uint256","name":"renounceOwnershipStart","type":"uint256"},{"internalType":"uint256","name":"renounceOwnershipEnd","type":"uint256"}],"name":"LSP14NotInRenounceOwnershipInterval","type":"error"},{"inputs":[{"internalType":"bool","name":"postCall","type":"bool"},{"internalType":"bytes4","name":"returnedStatus","type":"bytes4"}],"name":"LSP20CallVerificationFailed","type":"error"},{"inputs":[{"internalType":"bool","name":"postCall","type":"bool"}],"name":"LSP20CallingVerifierFailed","type":"error"},{"inputs":[{"internalType":"address","name":"logicVerifier","type":"address"}],"name":"LSP20EOACannotVerifyCall","type":"error"},{"inputs":[{"internalType":"bytes4","name":"functionSelector","type":"bytes4"}],"name":"NoExtensionFoundForFunctionSelector","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"operationType","type":"uint256"},{"indexed":true,"internalType":"address","name":"contractAddress","type":"address"},{"indexed":true,"internalType":"uint256","name":"value","type":"uint256"},{"indexed":false,"internalType":"bytes32","name":"salt","type":"bytes32"}],"name":"ContractCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"dataKey","type":"bytes32"},{"indexed":false,"internalType":"bytes","name":"dataValue","type":"bytes"}],"name":"DataChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"operationType","type":"uint256"},{"indexed":true,"internalType":"address","name":"target","type":"address"},{"indexed":true,"internalType":"uint256","name":"value","type":"uint256"},{"indexed":false,"internalType":"bytes4","name":"selector","type":"bytes4"}],"name":"Executed","type":"event"},{"anonymous":false,"inputs":[],"name":"OwnershipRenounced","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferStarted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[],"name":"RenounceOwnershipStarted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"uint256","name":"value","type":"uint256"},{"indexed":true,"internalType":"bytes32","name":"typeId","type":"bytes32"},{"indexed":false,"internalType":"bytes","name":"receivedData","type":"bytes"},{"indexed":false,"internalType":"bytes","name":"returnedValue","type":"bytes"}],"name":"UniversalReceiver","type":"event"},{"stateMutability":"payable","type":"fallback"},{"inputs":[],"name":"RENOUNCE_OWNERSHIP_CONFIRMATION_DELAY","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"RENOUNCE_OWNERSHIP_CONFIRMATION_PERIOD","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"VERSION","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"acceptOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes[]","name":"data","type":"bytes[]"}],"name":"batchCalls","outputs":[{"internalType":"bytes[]","name":"results","type":"bytes[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"operationType","type":"uint256"},{"internalType":"address","name":"target","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"}],"name":"execute","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"operationsType","type":"uint256[]"},{"internalType":"address[]","name":"targets","type":"address[]"},{"internalType":"uint256[]","name":"values","type":"uint256[]"},{"internalType":"bytes[]","name":"datas","type":"bytes[]"}],"name":"executeBatch","outputs":[{"internalType":"bytes[]","name":"","type":"bytes[]"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"dataKey","type":"bytes32"}],"name":"getData","outputs":[{"internalType":"bytes","name":"dataValue","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32[]","name":"dataKeys","type":"bytes32[]"}],"name":"getDataBatch","outputs":[{"internalType":"bytes[]","name":"dataValues","type":"bytes[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"dataHash","type":"bytes32"},{"internalType":"bytes","name":"signature","type":"bytes"}],"name":"isValidSignature","outputs":[{"internalType":"bytes4","name":"returnedStatus","type":"bytes4"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pendingOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"dataKey","type":"bytes32"},{"internalType":"bytes","name":"dataValue","type":"bytes"}],"name":"setData","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes32[]","name":"dataKeys","type":"bytes32[]"},{"internalType":"bytes[]","name":"dataValues","type":"bytes[]"}],"name":"setDataBatch","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"pendingNewOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"typeId","type":"bytes32"},{"internalType":"bytes","name":"receivedData","type":"bytes"}],"name":"universalReceiver","outputs":[{"internalType":"bytes","name":"returnedValues","type":"bytes"}],"stateMutability":"payable","type":"function"},{"stateMutability":"payable","type":"receive"}]',
  'LSP0ERC725Account',
);

class LSP0ERC725Account extends _i1.GeneratedContract {
  LSP0ERC725Account({
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
  Future<BigInt> RENOUNCE_OWNERSHIP_CONFIRMATION_DELAY(
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'ead3fbdf'));
    final params = [];
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
  Future<BigInt> RENOUNCE_OWNERSHIP_CONFIRMATION_PERIOD(
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '01bfba61'));
    final params = [];
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
  Future<String> VERSION({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[4];
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
  Future<String> acceptOwnership({
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '79ba5097'));
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
  Future<String> batchCalls(
    List<_i2.Uint8List> data, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '6963d438'));
    final params = [data];
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
  Future<String> execute(
    BigInt operationType,
    _i1.EthereumAddress target,
    BigInt value,
    _i2.Uint8List data, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '44c028fe'));
    final params = [
      operationType,
      target,
      value,
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
  Future<String> executeBatch(
    List<BigInt> operationsType,
    List<_i1.EthereumAddress> targets,
    List<BigInt> values,
    List<_i2.Uint8List> datas, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '31858452'));
    final params = [
      operationsType,
      targets,
      values,
      datas,
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
  Future<_i2.Uint8List> getData(
    _i2.Uint8List dataKey, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[9];
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
    final function = self.abi.functions[10];
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
  Future<_i2.Uint8List> isValidSignature(
    _i2.Uint8List dataHash,
    _i2.Uint8List signature, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[11];
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
  Future<_i1.EthereumAddress> owner({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, '8da5cb5b'));
    final params = [];
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
  Future<_i1.EthereumAddress> pendingOwner({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, 'e30c3978'));
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
  Future<String> setData(
    _i2.Uint8List dataKey,
    _i2.Uint8List dataValue, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[15];
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
    final function = self.abi.functions[16];
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
    final function = self.abi.functions[17];
    assert(checkSignature(function, '01ffc9a7'));
    final params = [interfaceId];
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
  Future<String> transferOwnership(
    _i1.EthereumAddress pendingNewOwner, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, 'f2fde38b'));
    final params = [pendingNewOwner];
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
  Future<String> universalReceiver(
    _i2.Uint8List typeId,
    _i2.Uint8List receivedData, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, '6bb56a14'));
    final params = [
      typeId,
      receivedData,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all ContractCreated events emitted by this contract.
  Stream<ContractCreated> contractCreatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('ContractCreated');
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
      return ContractCreated(
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

  /// Returns a live stream of all Executed events emitted by this contract.
  Stream<Executed> executedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Executed');
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
      return Executed(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all OwnershipRenounced events emitted by this contract.
  Stream<OwnershipRenounced> ownershipRenouncedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OwnershipRenounced');
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
      return OwnershipRenounced(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all OwnershipTransferStarted events emitted by this contract.
  Stream<OwnershipTransferStarted> ownershipTransferStartedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OwnershipTransferStarted');
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
      return OwnershipTransferStarted(
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

  /// Returns a live stream of all RenounceOwnershipStarted events emitted by this contract.
  Stream<RenounceOwnershipStarted> renounceOwnershipStartedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('RenounceOwnershipStarted');
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
      return RenounceOwnershipStarted(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all UniversalReceiver events emitted by this contract.
  Stream<UniversalReceiver> universalReceiverEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('UniversalReceiver');
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
      return UniversalReceiver(
        decoded,
        result,
      );
    });
  }
}

class ContractCreated {
  ContractCreated(
    List<dynamic> response,
    this.event,
  )   : operationType = (response[0] as BigInt),
        contractAddress = (response[1] as _i1.EthereumAddress),
        value = (response[2] as BigInt),
        salt = (response[3] as _i2.Uint8List);

  final BigInt operationType;

  final _i1.EthereumAddress contractAddress;

  final BigInt value;

  final _i2.Uint8List salt;

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

class Executed {
  Executed(
    List<dynamic> response,
    this.event,
  )   : operationType = (response[0] as BigInt),
        target = (response[1] as _i1.EthereumAddress),
        value = (response[2] as BigInt),
        selector = (response[3] as _i2.Uint8List);

  final BigInt operationType;

  final _i1.EthereumAddress target;

  final BigInt value;

  final _i2.Uint8List selector;

  final _i1.FilterEvent event;
}

class OwnershipRenounced {
  OwnershipRenounced(
    List<dynamic> response,
    this.event,
  );

  final _i1.FilterEvent event;
}

class OwnershipTransferStarted {
  OwnershipTransferStarted(
    List<dynamic> response,
    this.event,
  )   : previousOwner = (response[0] as _i1.EthereumAddress),
        newOwner = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress previousOwner;

  final _i1.EthereumAddress newOwner;

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

class RenounceOwnershipStarted {
  RenounceOwnershipStarted(
    List<dynamic> response,
    this.event,
  );

  final _i1.FilterEvent event;
}

class UniversalReceiver {
  UniversalReceiver(
    List<dynamic> response,
    this.event,
  )   : from = (response[0] as _i1.EthereumAddress),
        value = (response[1] as BigInt),
        typeId = (response[2] as _i2.Uint8List),
        receivedData = (response[3] as _i2.Uint8List),
        returnedValue = (response[4] as _i2.Uint8List);

  final _i1.EthereumAddress from;

  final BigInt value;

  final _i2.Uint8List typeId;

  final _i2.Uint8List receivedData;

  final _i2.Uint8List returnedValue;

  final _i1.FilterEvent event;
}
