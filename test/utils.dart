import 'dart:async';

import 'package:karma_coin/common_libs.dart';
import 'package:karma_coin/data/verify_number_request.dart';
import 'package:karma_coin/logic/identity.dart';
import 'package:karma_coin/logic/identity_interface.dart';
import 'package:karma_coin/logic/verifier.dart';
import 'package:karma_coin/services/v2.0/user_info.dart';

final random = Random.secure();
String get randomPhoneNumber => '+${(random.nextInt(900000) + 100000)}';

class TestUserInfo {
  IdentityInterface user;
  KC2UserInfo? userInfo;
  String? newUserTxHash;

  String get phoneNumberHash => userInfo!.phoneNumberHash;
  String get phoenNumber => user.phoneNumber!;
  String get accountId => user.accountId;
  String get userName => userInfo!.userName;

  TestUserInfo(this.user, this.userInfo, this.newUserTxHash);
}

/// Create a new test user and sign it up to the chain
/// Returns usable user info data
Future<TestUserInfo> createLocalUser(
    {required Completer<bool> completer}) async {
  if (!kc2Service.connectedToApi) {
    await kc2Service.connectToApi(apiWsUrl: 'ws://127.0.0.1:9944');
  }
  IdentityInterface user = Identity();
  await user.initNoStorage();
  String userName = "katya${user.accountId.substring(0, 5)}".toLowerCase();
  String phoneNumber = randomPhoneNumber;
  user.setPhoneNumber(phoneNumber);

  debugPrint(
      'Creating user: $userName, phone: $phoneNumber, accountId: ${user.accountId}');

  // Set user as signer - required for newUser() tx
  kc2Service.setKeyring(user.keyring);

  // Create a verification request for verifier with a bypass token or with
  // a verification code and session id from app state
  VerifyNumberRequest req = await verifier.createVerificationRequest(
      accountId: user.accountId,
      userName: userName,
      phoneNumber: phoneNumber,
      keyring: user.keyring,
      useBypassToken: true);

  debugPrint('Calling verifier...');

  VerifyNumberData vd = await verifier.verifyNumber(req);
  if (vd.data == null || vd.error != null) {
    completer.complete(false);
    return TestUserInfo(user, null, null);
  }

  String? err;
  String? txHash;

  debugPrint('Signin up user...');

  (txHash, err) = await kc2Service.newUser(evidence: vd.data!);
  if (err != null) {
    completer.completeError(err);
    return TestUserInfo(user, null, null);
  }

  KC2UserInfo userInfo = KC2UserInfo(
      accountId: user.accountId,
      phoneNumberHash: kc2Service.getPhoneNumberHash(phoneNumber),
      userName: userName,
      balance: BigInt.zero);

  debugPrint('NewUser tx submitted');
  return TestUserInfo(user, userInfo, txHash);
}
