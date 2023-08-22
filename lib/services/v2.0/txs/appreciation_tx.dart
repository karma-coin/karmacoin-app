import 'package:convert/convert.dart';
import 'package:karma_coin/common_libs.dart';
import 'package:karma_coin/data/genesis_config.dart';
import 'package:karma_coin/data/personality_traits.dart';
import 'package:karma_coin/services/v2.0/error.dart';
import 'package:karma_coin/services/v2.0/event.dart';
import 'package:karma_coin/services/v2.0/txs/tx.dart';
import 'package:karma_coin/services/v2.0/user_info.dart';
import 'package:ss58/ss58.dart' as ss58;

/// A basic appreciation tx based on on-chain data only
/// Use KC2EnrichedAppreciationTxV1 for additional on-chain data
class KC2AppreciationTxV1 extends KC2Tx {
  String fromAddress;

  String? fromUserName;

  // non-null if apprecaition was to a phone number hash or enriched
  String? toPhoneNumberHash;

  // non-null if appreciation was to a username or enriched
  String? toUserName;

  // non-null if apprecaition was to an account id enriched
  String? toAccountId;

  BigInt amount;
  int? communityId;
  int? charTraitId;

  /// Create an apprecaition tx from the provided tx data w/o any RPC enrichments
  static Future<KC2AppreciationTxV1> createAppreciationTx(
      {required String hash,
      required int timestamp,
      required String signer,
      required Map<String, dynamic> args,
      required ChainError? failedReason,
      required BigInt blockNumber,
      required int blockIndex,
      required Map<String, dynamic> rawData,
      required List<KC2Event> txEvents,
      required int netId}) async {
    try {
      // debugPrint("Appreciation tx args: $args");
      final to = args['to'];
      final accountIdentityType = to.key;
      final accountIdentityValue = to.value;

      final BigInt amount = args['amount'];
      final int? communityId = args['community_id'].value;
      final int? charTraitId = args['char_trait_id'].value;

      String? toAccountId;
      String? toUserName;
      String? toPhoneNumberHash;

      // Extract one of the destination fields from the tx
      switch (accountIdentityType) {
        case 'AccountId':
          toAccountId =
              ss58.Codec(netId).encode(accountIdentityValue.cast<int>());

          break;
        case 'Username':
          toUserName = accountIdentityValue;
          break;
        default:
          toPhoneNumberHash =
              '0x${hex.encode(accountIdentityValue.cast<int>())}';
          break;
      }

      return KC2AppreciationTxV1(
        fromAddress: signer,
        toPhoneNumberHash: toPhoneNumberHash,
        toUserName: toUserName,
        toAccountId: toAccountId,
        amount: amount,
        communityId: communityId,
        charTraitId: charTraitId,
        args: args,
        signer: signer,
        failedReason: failedReason,
        timestamp: timestamp,
        hash: hash,
        blockNumber: blockNumber,
        blockIndex: blockIndex,
        transactionEvents: txEvents,
        rawData: rawData,
      );
    } catch (e) {
      debugPrint("Error processing appreciation tx: $e");
      rethrow;
    }
  }

  KC2AppreciationTxV1(
      {required this.fromAddress,
      this.toPhoneNumberHash,
      this.toAccountId,
      this.toUserName,
      required this.amount,
      this.communityId = 0,
      this.charTraitId = 0,
      required super.transactionEvents,
      required super.args,
      required super.failedReason,
      required super.timestamp,
      required super.hash,
      required super.blockNumber,
      required super.blockIndex,
      required super.rawData,
      required super.signer});

  String getTitle() {
    if (charTraitId != null &&
        charTraitId != 0 &&
        charTraitId! < GenesisConfig.personalityTraits.length) {
      PersonalityTrait trait = GenesisConfig.personalityTraits[charTraitId!];
      return '${trait.emoji} You are ${trait.name.toLowerCase()}';
    } else {
      return '🤑 Karma Coin Transfer';
    }
  }

  /// Enrich the tx with additional data from the chain based on a user's identity
  Future<void> enrichForUser(KC2UserInfo userInfo) async {
    // enrich from user name
    if (userInfo.accountId == signer) {
      fromUserName = userInfo.userName;
      return;
    } else {
      final res = await kc2Service.getUserInfoByAccountId(signer);
      fromUserName = res?.userName;
    }

    // enrich reciver's data based on toAccountId info
    if (toAccountId == signer) {
      toUserName = userInfo.userName;
      toPhoneNumberHash = userInfo.phoneNumberHash;
      return;
    } else if (toAccountId != null) {
      // receiver is not the user - obtain info from api
      final res = await kc2Service.getUserInfoByAccountId(toAccountId!);
      // complete tx data fields from info
      toUserName = res?.userName;
      toPhoneNumberHash = res?.phoneNumberHash;
      return;
    }

    // enrich reciver's data based on receiver's user name
    if (toUserName != null) {
      if (toUserName != userInfo.userName) {
        // call api to get missing fields
        final res = await kc2Service.getUserInfoByUserName(toUserName!);
        toAccountId = res?.accountId;
        toPhoneNumberHash = res?.phoneNumberHash;
        return;
      } else {
        toAccountId = userInfo.accountId;
        toPhoneNumberHash = userInfo.phoneNumberHash;
        return;
      }
    }

    final res =
        await kc2Service.getUserInfoByPhoneNumberHash(toPhoneNumberHash!);
    // complete missing fields in tx with data from api
    toAccountId = res?.accountId;
    toUserName = res?.userName;
  }
}
