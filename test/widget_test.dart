import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp/services/encryption.dart' as encryption;
import 'package:mobileapp/services/utils.dart';

void main() {
  // test('test server', () async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   GetIt.instance.registerSingleton<NetworkService>(NetworkService());

  //   final server = SigningServer();
  //   await server.start(8000);
  //   await Future.delayed(const Duration(seconds: 60000));
  // });

  test('compress json', () {
    var compressed = compressJson(jsonDecode(
            '''{"id":"SI5130889317067741","blockchain":"BITCOIN","coin":"BTC","pubkey":"03ea000bfee287b950ae7246457b0b77d938170271461fe1d3eb56e258c478c027","fromAddress":"mvT7jKHfQyUFrrhiRiBtQfGnNNfmNr8Mxv","threshold":1,"requestTransactionType":"SEND","status":"SIGNING_PREPARATION","signingResult":{"signingHashes":[{"state":{"t":1,"n":2,"signing_parts_base64":[{"party_id":1,"part_base64":"eyJjdXJ2ZSI6InNlY3AyNTZrMSIsInNjYWxhciI6Wzc4LDQ2LDExMiwyNTAsOCwyMjEsMjIsMTI3LDQ2LDcyLDkyLDE1OSwxMzcsNiwxNDMsNDEsMTc0LDkxLDQ2LDIyNSw4MiwyMDIsMTA0LDk3LDEwNiw2MSwxMzAsMTM0LDIyMCwxMzUsMTQwLDE3NF19","signed_at":"2023-03-23T23:51:05.809Z"},{"party_id":2,"part_base64":"eyJjdXJ2ZSI6InNlY3AyNTZrMSIsInNjYWxhciI6WzE5LDE0LDE2NSwxMTcsMjA0LDIxMyw1NSwxMjksMTgxLDE0OCwxNzYsMzIsMTQ2LDE2LDgyLDExMSwyNTMsMjAsMjI5LDg2LDE0OSwxMTQsNTQsMTA1LDExOCwxMzMsMTM2LDE0OCwyMjIsMTAzLDEzMyw5M119","signed_at":"2023-03-23T23:52:28.205Z"}],"signature_hex":{"r":"0b5e6ebf9c3e51cde4298974d123753615444be957e368d6ebaf6f89c3fec327","s":"613d166fd5b24e00e3dd0cc01b16e199ab701437e83c9ecae0c30b1bbaef120b","recid":0}},"hash":"b4b762a7f0aacb3f7968cd41d2032c32929d61d609ad3622b948a6f2943e65a1"}],"unsignedTransaction":"0100000001214228e37fb2efa5f696245ff432909bbe1ab00f701e42b79a03a77816ff8644010000001976a914a3d0196c8ff87ad04db851a6d6c41f1e7890e7ca88acffffffff02e8030000000000001976a91444606d603fd51b650f06fa17a23ed0be7f729d8488accd0b0000000000001976a914a3d0196c8ff87ad04db851a6d6c41f1e7890e7ca88ac00000000","transactionHash":null,"signedTransaction":null},"sendRequest":{"toAddress":"mmkVkysF5sssp54wgSpXjR5uqRz8ix6qYZ","amount":"0.00001"},"signers":[1,2],"feeLevel":"MEDIUM","createdAt":"2023-03-22T22:27:31.522929"}''')
        as Map<String, dynamic>);
    print(compressed);
    print(compressed.length);
    var decompressed = jsonEncode(decompressJson(compressed));
    print(decompressed);
    print(decompressed.length);
  });

  test('encryption', () async {
    var encrypted =
        await encryption.encryptWithNonce("hello", "my-password", 9999999);
    expect(encrypted, "9999999:dYcX59XzlgaRJP82ogwUIb5zvxzX");
    var plaintext = await encryption.decryptWithNonce(
        "dYcX59XzlgaRJP82ogwUIb5zvxzX", "my-password", 9999999);
    expect(plaintext, "hello");
  });
}
