import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter_test/flutter_test.dart';

class A {
  A({required this.id});

  final int id;

  List<dynamic> getId() => [id];
}

class B extends A {
  B({required super.id, required this.name});

  String name;

  @override
  List<dynamic> getId() => [name, id];
}

void main() {
  group('stuff', () {
    test('stuuuuuuuuuuuuuuf', () {
      final g = B(id: 2, name: 'fuck');
      void pt(A a) {
        print(a.getId());
      }

      pt(g);
    });
  });

  group('Counter', () {
    test('VALUE AFTER ENCRYPTION CHANGED', () async {
      // await dotenv.load();
      // final encryptor = AESEncryption();
      // final data = PassKey(
      //   description: 'This a description \n mowiiashdoiasjd\n fuck me',
      //   docId: DateTime.now().hashCode,
      //   passKey: 'pooop',
      //   org: 'nunya',
      //   email: 'topasd.lasjkd@gmoasl.com',
      //   username: 'poaspdlkaskld', syncStatus: SyncStatus.synced,
      // );
      // final data2 = data;
      // data2.crypt(encryptor.encrypt);
      // data2.crypt(encryptor.decrypt);
      // expect(data2.passKey, data.passKey);
    });
  });

  test('test random generator', () {
    const length = 5;
    final da = idGenerator(length: length);
    expect(da.runtimeType, int);
    expect(
      da.toString().length,
      length,
    );
  });
}
