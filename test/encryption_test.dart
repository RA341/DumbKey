import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/utils/passkey_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Counter', () {
    test('VALUE AFTER ENCRYPTION CHANGED', () async {
      await dotenv.load();
      final encryptor = AESEncryption();
      final data = PassKey(
        description: 'This a description \n mowiiashdoiasjd\n fuck me',
        docId: DateTime.now().hashCode.toString(),
        passKey: 'pooop',
        org: 'nunya',
        email: 'topasd.lasjkd@gmoasl.com',
        username: 'poaspdlkaskld',
      );
      final data2 = data;
      data2.crypt(encryptor.encrypt);
      data2.crypt(encryptor.decrypt);
      expect(data2.passKey, data.passKey);
    });
  });
}
