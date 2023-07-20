import 'dart:async';

import 'package:karma_coin/logic/kc2/keyring.dart';
import 'package:karma_coin/services/v2.0/events.dart';
import 'package:karma_coin/services/v2.0/types.dart';
import 'package:substrate_metadata_fixed/models/models.dart';

abstract class K2ServiceInterface {
  /// Available after connectToApi() called and completed without an error
  ChainInfo get chainInfo;

  /// Get the service's events handler and register on events using its props
  KC2EventsHandler get eventsHandler;

  /// Set an identity's keyring - call with local user's identity keyring on new app session
  void setKeyring(KC2KeyRing keyring);

  // Connect to a karmachain api service. e.g
  // Local running node - "ws://127.0.0.1:9944"
  // Testnet - "wss://testnet.karmaco.in/testnet/ws"
  Future<void> connectToApi(String wsUrl);

  // rpc methods

  // accountId - ss58 address
  Future<Map<String, dynamic>?> getUserInfoByAccountId(String accountId);

  Future<Map<String, dynamic>?> getUserInfoByUsername(String username);

  Future<Map<String, dynamic>?> getUserInfoByPhoneNumberHash(
      String phoneNumberHash);

  Future<List<Event>> getTransactionEvents(
      int blockNumber, int transactionIndex);

  // transactions

  // accountId - ss58 encoded user's public ed25519 key
  // userName - unique username. Must not be empty
  // phoneNumber - user's phone number. Including country code. Excluding leading +
  Future<void> newUser(String accountId, String username, String phoneNumber);

  Future<void> updateUser(String? username, String? phoneNumberHash);

  // phoneNumberHash - canonical hex string of phone number hash using blake32.
  // use getPhoneNumberHash() to get hash from a number
  Future<void> sendAppreciation(
      String phoneNumberHash, int amount, int communityId, int charTraitId);

  Future<void> setAdmin(int communityId, String accountId);

  // events

  /// Subscribe to new account tranactions  address - ss58 accountId
  /// Transactions will be delivered to a registered event handler
  Timer subscribeToAccount(String accountId);

  // Get all transactions from chain to or from an account
  Future<void> getTransactions(String accountId);

  // helpers

  /// Get canonical hex string of a phone number
  String getPhoneNumberHash(String phoneNumber);
}
