import 'package:karma_coin/common_libs.dart';
import 'package:karma_coin/data/signer_mixin.dart';
import 'package:karma_coin/services/api/verifier.pb.dart' as vt;
import 'package:karma_coin/services/api/types.pb.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

/// An extension class over vt.VerifyNumberRequest to support signing and verification
class VerifyNumberRequest implements Signer {
  final vt.VerifyNumberRequest request;
  VerifyNumberRequest(this.request);

  @override
  void sign(ed.PrivateKey privateKey,
      {keyScheme = KeyScheme.KEY_SCHEME_ED25519}) {
    Uint8List signature = ed.sign(privateKey, request.writeToBuffer());
    request.signature =
        Signature(scheme: keyScheme, signature: signature.toList());
  }

  @override
  bool verify(ed.PublicKey publicKey,
      {keyScheme = KeyScheme.KEY_SCHEME_ED25519}) {
    if (keyScheme != KeyScheme.KEY_SCHEME_ED25519) {
      debugPrint('Only ed scheme is supported');
      return false;
    }

    return ed.verify(publicKey, request.writeToBuffer(),
        request.signature.signature as Uint8List);
  }
}
