import 'dart:async';
import 'package:convert/convert.dart';
import 'package:karma_coin/common_libs.dart';
import 'package:karma_coin/logic/app_state.dart';
import 'package:karma_coin/services/v2.0/event.dart';
import 'package:karma_coin/services/v2.0/interfaces.dart';
import 'package:karma_coin/services/v2.0/nomination_pools/nomination_pools_configuration.dart';
import 'package:karma_coin/services/v2.0/txs/tx.dart';
import 'package:karma_coin/services/v2.0/types.dart';
import 'package:karma_coin/services/v2.0/user_info.dart';
import 'package:polkadart/scale_codec.dart';
import 'package:polkadart/substrate/substrate.dart';
import 'package:substrate_metadata_fixed/types/metadata_types.dart';

/// Client callback types
typedef NewUserCallback = Future<void> Function(KC2NewUserTransactionV1 tx);
typedef UpdateUserCallback = Future<void> Function(KC2UpdateUserTxV1 tx);
typedef RemoveMetadataCallback = Future<void> Function(
    KC2RemoveMetadataTxV1 tx);
typedef SetMetadataCallback = Future<void> Function(KC2SetMetadataTxV1 tx);
typedef AppreciationCallback = Future<void> Function(KC2AppreciationTxV1 tx);
typedef TransferCallback = Future<void> Function(KC2TransferTxV1 tx);

enum FetchAppreciationsStatus { idle, fetching, fetched, error }

mixin K2ServiceInterface implements ChainApiProvider {
  /// Get the chain's existential deposit amount
  BigInt get existentialDeposit;

  bool get connectedToApi;

  /// Number of blocks in an epoch
  int get blocksPerEpoch;

  /// Expected block time miliseconds
  int get expectedBlockTimeMs;

  /// Expected block time in seconds
  int get expectedBlockTimeSeconds;

  /// Expected epoch duration in seconds
  int get epochDurationSeconds;

  /// Number of eras in an epoch
  int get epochsPerEra;

  /// Expected era duraiton in seconds
  int get eraTimeSeconds;

  /// Currently connected API URL
  String? get apiWsUrl;

  /// Hasher to use with phone number
  Blake2bHasher hasher = const Blake2bHasher(64);

  /// Chains pool configuration
  NominationPoolsConfiguration get poolsConfiguration;

  /// Connect to a karmachain api service. e.g
  /// Local running node - "ws://127.0.0.1:9944"
  /// Testnet - "wss://testnet.karmaco.in/testnet/ws"
  Future<void> connectToApi({required String apiWsUrl});

  // rpc methods

  Future<String> getNodeVersion();

  /// Provides information about user account by `AccountId`
  Future<KC2UserInfo?> getUserInfoByAccountId(String accountId) async {
    try {
      Map<String, dynamic>? result =
          await callRpc('identity_getUserInfoByAccountId', [accountId]);
      return result == null ? null : KC2UserInfo.fromJson(result);
    } catch (e) {
      debugPrint('Failed to get user information by account id: $e');
      rethrow;
    }
  }

  /// Provides information about user account by `Username`
  Future<KC2UserInfo?> getUserInfoByUserName(String username) async {
    try {
      Map<String, dynamic>? result =
          await callRpc('identity_getUserInfoByUsername', [username]);
      return result == null ? null : KC2UserInfo.fromJson(result);
    } catch (e) {
      debugPrint('Failed to get user information by username: $e');
      rethrow;
    }
  }

  /// Provides information about user account by `PhoneNumber`
  ///
  /// Use getPhoneNumberHash of an international number w/o leading '+'.
  /// Hex string may be 0x prefixed or not
  Future<KC2UserInfo?> getUserInfoByPhoneNumberHash(
      String phoneNumberHash) async {
    try {
      // Cut `0x` prefix if exists
      if (phoneNumberHash.startsWith('0x')) {
        phoneNumberHash = phoneNumberHash.substring(2);
      }

      Map<String, dynamic>? result = await callRpc(
          'identity_getUserInfoByPhoneNumberHash', [phoneNumberHash]);
      return result == null ? null : KC2UserInfo.fromJson(result);
    } catch (e) {
      debugPrint('Failed to get user information by phone number hash: $e');
      rethrow;
    }
  }

  /// Fetch list of community members with information
  /// about each member account
  Future<List<KC2UserInfo>> getCommunityMembers(int communityId,
      {int? fromIndex, int? limit}) async {
    try {
      List<dynamic> result = await callRpc(
          'community_getAllUsers', [communityId, fromIndex, limit]);

      return result.map((e) => KC2UserInfo.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Failed to get community members: $e');
      rethrow;
    }
  }

  /// Fetch list of users who's username starts with `prefix`
  /// Can be filtered by `communityId`. Pass null communityId for no filtering
  Future<List<Contact>> getContacts(String prefix,
      {int? communityId, int? fromIndex, int? limit}) async {
    try {
      List<dynamic> result = await callRpc(
          'community_getContacts', [prefix, communityId, fromIndex, limit]);
      return result.map((e) => Contact.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Failed to get contacts: $e');
      rethrow;
    }
  }

  /// Fetch list who participate in karma rewards distribution
  Future<List<KC2UserInfo>> getLeaderBoard() async {
    try {
      List<dynamic> result = await callRpc('community_getLeaderBoard', []);
      return result.map((e) => KC2UserInfo.fromJson(e)).toList();
    } on PlatformException catch (e) {
      debugPrint('Failed to get leader board: ${e.message}');
      rethrow;
    }
  }

  /// Fetch information about chain like last block time, rewards, etc
  Future<BlockchainStats> getBlockchainStats() async {
    try {
      Map<String, dynamic> result =
          await callRpc('chain_getBlockchainData', []);
      return BlockchainStats.fromJson(result);
    } catch (e) {
      debugPrint('Failed to get blockchain stats: $e');
      rethrow;
    }
  }

  Future<String> getNetName() async {
    try {
      return await callRpc('chain_getNetworkId', []);
    } on PlatformException catch (e) {
      debugPrint('Failed to get net id: ${e.message}');
      rethrow;
    }
  }

  /// Fetch supported by the chain char traits
  Future<List<CharTrait>> getCharTraits() async {
    try {
      List<dynamic> result = await callRpc('chain_getCharTraits', []);
      return result.map((e) => CharTrait.fromJson(e)).toList();
    } on PlatformException catch (e) {
      debugPrint('Failed to get char traits: ${e.message}');
      rethrow;
    }
  }

  /// Fetch chain genesis time
  Future<int> getGenesisTimestamp();

  /// Convert RPC `Transaction` type to `KC2Tx` type
  Future<KC2Tx?> _convertTransaction(Transaction transaction) async {
    final extrinsic = ExtrinsicsCodec(chainInfo: chainInfo)
        .decode(Input.fromBytes(transaction.transaction.transactionBody));

    String hash = hex.encode(Hasher.blake2b256
        .hash(ExtrinsicsCodec(chainInfo: chainInfo).encode(extrinsic)));

    return await KC2Tx.getKC2Transaction(
        tx: extrinsic,
        // If transaction indexed on-chain, it is successful
        chainError: null,
        timestamp: transaction.timestamp,
        hash: hash,
        blockNumber: BigInt.from(transaction.blockNumber),
        blockIndex: transaction.transactionIndex,
        txEvents: transaction.events.map((e) => KC2Event.fromJson(e)).toList(),
        signer: transaction.from!.accountId,
        netId: netId,
        chainInfo: chainInfo);
  }

  /// Fetch transaction by block number and transaction index
  Future<KC2Tx?> getTransaction(int blockNumber, int txIndex) async {
    try {
      Map<String, dynamic> result =
          await callRpc('chain_getTransaction', [blockNumber, txIndex]);
      final transaction = Transaction.fromJson(result);
      return await _convertTransaction(transaction);
    } on PlatformException catch (e) {
      debugPrint('Failed to get transactions_getTx: ${e.message}');
      rethrow;
    }
  }

  /// Fetch transaction by transaction hash
  Future<KC2Tx?> getTransactionByHash(String txHash) async {
    try {
      Map<String, dynamic> result =
          await callRpc('transactions_getTransaction', [txHash]);
      final transaction = Transaction.fromJson(result);
      return await _convertTransaction(transaction);
    } on PlatformException catch (e) {
      debugPrint('Failed to get transactions_getTx: ${e.message}');
      rethrow;
    }
  }

  /// Fetch all transaction belong to the account id
  Future<List<KC2Tx>> getTransactionsByAccountId(String accountId) async {
    try {
      List<dynamic> result =
          await callRpc('transactions_getTransactions', [accountId]);
      final transactions = result.map((e) => Transaction.fromJson(e)).toList();

      List<KC2Tx> txs = [];
      for (final transaction in transactions) {
        final tx = await _convertTransaction(transaction);
        if (tx != null) {
          txs.add(tx);
        }
      }
      return txs;
    } on PlatformException catch (e) {
      debugPrint(
          'Failed to get transactions_getTransactionsByAccountId: ${e.message}');
      rethrow;
    }
  }

  Future<List<KC2Tx>> getTransactionsByPhoneNumberHash(
      String phoneNumberHash) async {
    try {
      // Cut `0x` prefix if exists
      if (phoneNumberHash.startsWith('0x')) {
        phoneNumberHash = phoneNumberHash.substring(2);
      }

      List<dynamic> result = await callRpc(
          'transactions_getTransactionsByPhoneNumberHash', [phoneNumberHash]);
      final transactions = result.map((e) => Transaction.fromJson(e)).toList();

      List<KC2Tx> txs = [];
      for (final transaction in transactions) {
        final tx = await _convertTransaction(transaction);
        if (tx != null) {
          txs.add(tx);
        }
      }
      return txs;
    } on PlatformException catch (e) {
      debugPrint(
          'Failed to get transactions_getTransactionsByPhoneNumberHash: ${e.message}');
      rethrow;
    }
  }

  Future<String?> getMetadata(String accountId) async {
    try {
      List<dynamic>? result =
          await callRpc('identity_getMetadata', [accountId]);
      return result == null ? null : String.fromCharCodes(result.cast<int>());
    } on PlatformException catch (e) {
      debugPrint('Failed to get account metadata: ${e.message}');
      rethrow;
    }
  }

  // transactions

  /// Create a new on-chain user with provided verification evidence
  Future<(String?, String?)> newUser(
      {required VerificationEvidence evidence}) async {
    try {
      // Verification failed
      if (evidence.verificationResult != VerificationResult.verified) {
        return (null, evidence.verificationResult.toString());
      }

      final Uint8List phoneNumberHash =
          Uint8List.fromList(evidence.phoneNumberHash.toHex());

      final call = MapEntry(
          'Identity',
          MapEntry('new_user', {
            'verifier_public_key': decodeAccountId(evidence.verifierAccountId),
            'verifier_signature': evidence.signature,
            'account_id': decodeAccountId(evidence.accountId),
            'username': evidence.username,
            'phone_number_hash': phoneNumberHash,
          }));

      return (await signAndSendTransaction(call), null);
    } on PlatformException catch (e) {
      debugPrint('Failed to send signup tx: ${e.details}');
      return (null, "FailedToSendTx");
    }
  }

  /// Update user's phone number or user name
  /// username - new user name. If null, user name will not be updated
  /// phoneNumber - new phone number. If null, phone number will not be updated
  /// One of username and phoneNumber must not be null and should be different
  /// than current on-chain value
  /// Returns an (evidence, errorMessage) result.
  ///
  /// Implementation will attempt to obtain verifier evidence regarding the association between the accountId, and the new userName or the new phoneNumber
  Future<(String?, String?)> updateUser(
      {String? username,
      String? phoneNumberHash,
      VerificationEvidence? evidence}) async {
    try {
      Option<Uint8List?> verifierPublicKeyOption = const Option.none();
      Option<List<int>> verifierSignatureOption = const Option.none();
      Option<Uint8List> phoneNumberHashOption = const Option.none();
      Option<String> userNameOption = const Option.none();

      if (evidence != null) {
        Uint8List? verifierPublicKey =
            decodeAccountId(evidence.verifierAccountId);
        List<int>? verifierSignature = evidence.signature;

        if (phoneNumberHash == null) {
          return (null, "UsernameOrPhoneNumberMustBeProvided");
        }

        verifierPublicKeyOption = Option.some(verifierPublicKey);
        verifierSignatureOption = Option.some(verifierSignature);

        phoneNumberHashOption =
            Option.some(Uint8List.fromList(phoneNumberHash.toHex()));
      } else {
        if (username == null) {
          return (null, "UsernameOrPhoneNumberMustBeProvided");
        }
        userNameOption = Option.some(username);
      }

      final call = MapEntry(
          'Identity',
          MapEntry('update_user', {
            'verifier_public_key': verifierPublicKeyOption,
            'verifier_signature': verifierSignatureOption,
            'username': userNameOption,
            'phone_number_hash': phoneNumberHashOption,
          }));

      return (await signAndSendTransaction(call), null);
    } catch (e) {
      debugPrint('Failed to update user: $e');
      return (null, "FailedToSendTx");
    }
  }

  /// Delete user from chain
  Future<String> deleteUser() async {
    try {
      const call = MapEntry(
        'Identity',
        MapEntry(
          'delete_user',
          <String, dynamic>{},
        ),
      );

      String deleteAccountTxId = await signAndSendTransaction(call);
      debugPrint('Account deletion tx submitted');
      return deleteAccountTxId;
    } catch (e) {
      debugPrint('Failed to delete account: $e}');
      rethrow;
    }
  }

  /// Set metadata for the account. In case if metadata is already set, it will be overwritten
  /// Returns tx hash
  Future<String> setMetadata(String metadata) async {
    try {
      final bytes = metadata.codeUnits;

      if (bytes.length > 256) {
        throw ArgumentError('Metadata must be less than 256 bytes');
      }

      final call = MapEntry(
        'Identity',
        MapEntry(
          'set_metadata',
          {
            'metadata': bytes,
          },
        ),
      );

      return await signAndSendTransaction(call);
    } on PlatformException catch (e) {
      debugPrint('Failed to set admin: ${e.details}');
      rethrow;
    }
  }

  /// Remove metadata for the account
  Future<String> removeMetadata() async {
    try {
      const call = MapEntry(
        'Identity',
        MapEntry(
          'remove_metadata',
          <String, dynamic>{},
        ),
      );

      return await signAndSendTransaction(call);
    } on PlatformException catch (e) {
      debugPrint('Failed to set admin: ${e.details}');
      rethrow;
    }
  }

  /// Transfer coins from local account to an account
  Future<String> sendTransfer(String accountId, BigInt amount) async {
    appState.txSubmissionStatus.value = TxSubmissionStatus.submitting;
    try {
      final call = MapEntry(
        'Balances',
        MapEntry(
          'transfer',
          {'dest': MapEntry('Id', decodeAccountId(accountId)), 'value': amount},
        ),
      );

      String txHash = await signAndSendTransaction(call);
      appState.txSubmissionStatus.value = TxSubmissionStatus.submitted;
      return txHash;
    } on PlatformException catch (e) {
      appState.txSubmissionStatus.value = TxSubmissionStatus.error;
      debugPrint('Failed to send transfer: ${e.details}');
      rethrow;
    }
  }

  /// Send a new appreciation with optional charTraitId
  /// phoneNumberHash - canonical hex string of phone number hash using blake32.
  /// Use getPhoneNumberHash() to get hash of a number
  /// Returns submitted transaction hash
  /// todo: add support for sending a appreciation to a user name. To, implement, get the phone number hash from the chain for user name or id via the RPC api and send appreciation to it. No need to appreciate by accountId.
  Future<String> sendAppreciation(String phoneNumberHash, BigInt amount,
      int communityId, int charTraitId) async {
    if (phoneNumberHash.startsWith('0x')) {
      phoneNumberHash = phoneNumberHash.substring(2);
    }
    appState.txSubmissionStatus.value = TxSubmissionStatus.submitting;

    try {
      final call = MapEntry(
        'Appreciation',
        MapEntry(
          'appreciation',
          {
            'to': MapEntry('PhoneNumberHash', hex.decode(phoneNumberHash)),
            'amount': amount,
            'community_id': Option.some(communityId),
            'char_trait_id': Option.some(charTraitId),
          },
        ),
      );

      String txHash = await signAndSendTransaction(call);
      appState.txSubmissionStatus.value = TxSubmissionStatus.submitted;
      return txHash;
    } on PlatformException catch (e) {
      debugPrint('Failed to send appreciation: ${e.details}');
      appState.txSubmissionStatus.value = TxSubmissionStatus.error;
      rethrow;
    }
  }

  /// Set a user to be a community admin. Only the community owner can call this method. Returns submitted transaction hash.
  Future<String> setAdmin(int communityId, String accountId) async {
    try {
      final call = MapEntry(
        'Appreciation',
        MapEntry(
          'set_admin',
          {
            'community_id': communityId,
            'new_admin': MapEntry('AccountId', decodeAccountId(accountId)),
          },
        ),
      );

      return await signAndSendTransaction(call);
    } on PlatformException catch (e) {
      debugPrint('Failed to set admin: ${e.details}');
      rethrow;
    }
  }

  // events

  /// Subscribe to account-related transactions
  /// accountId - ss58 encoded address
  /// Events will be delivered to registered event handlers
  Timer subscribeToAccountTransactions(KC2UserInfo userInfo);

  /// Get all transactions from chain to, or from an account provided via userInfo
  /// Transactions will be sent to registered event handlers based on their type
  Future<FetchAppreciationsStatus> getAccountTransactions(KC2UserInfo userInfo);

  // helpers

  /// Get canonical hex string hash of a phone number
  /// phoneNumber - international phone number without leading '+'
  /// When a leading '+' is included - it will be removed prior to hashing.
  String getPhoneNumberHash(String phoneNumber);

  // available client txs callbacks

  /// Callback when a new user transaction is processed for local user
  NewUserCallback? newUserCallback;

  /// Local user's account data update
  UpdateUserCallback? updateUserCallback;

  // todo: deleteUserCallback

  /// A transfer to or from local user
  TransferCallback? transferCallback;

  /// An appreciation to or from local user
  AppreciationCallback? appreciationCallback;

  // todo: setAdminCallback

  /// Callback when account set metadata
  SetMetadataCallback? setMetadataCallback;

  /// Callback when account remove metadata
  RemoveMetadataCallback? removeMetadataCallback;
}
