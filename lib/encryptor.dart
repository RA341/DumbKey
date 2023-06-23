import 'package:encrypt/encrypt.dart';

class AESEncryption{

  AESEncryption(){
    final key = Key.fromUtf8('');
    iv = IV.fromLength(16);
    encryptionManager = Encrypter(AES(key));
  }

  late final Encrypter encryptionManager;
  late final IV iv;

  static String encrypt(String data){
    return data;
  }
  static String decrypt(String data){
    return data;
  }
}