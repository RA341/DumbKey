class DumbData {
  static const String noKey = 'no key found';

  static const String firebaseApiKey = 'FIREBASE_APIKEY';
  static const String firebaseProjID = 'FIREBASE_PROJECTID';

  // fields for user
  static const String salt = 'salt';
  static const String uuid = 'uuid';
  static const String userCollection = 'users';
  static const String encryptionKey = 'encrypt';

  // common fields for all types
  static const String id = 'id';
  static const String dataType = 'dataType';
  static const String title = 'title';
  static const String dateAdded = 'dateAdded';
  static const String syncStatus = 'syncStatus';
  static const String nonce = 'nonce';

  // fields for passkey
  static const String email = 'email';
  static const String username = 'username';
  static const String password = 'password';
  static const String description = 'description';
  static const String category = 'category';

  // fields for credit card
  static const String cardNumber = 'cardNumber';
  static const String cardHolderName = 'cardHolderName';
  static const String expirationDate = 'expirationDate';
  static const String cvv = 'cvv';

  // fields for notes
  static const String notes = 'notes';

  ///keys that are not to be encrypted or decrypted anywhere
  static const blackListedKeys = [id, nonce];

  ///keys that are not to be encrypted or decrypted locally (helps in searching and syncing)
  static const blackListedKeysLocal = [syncStatus, dataType, dateAdded];
}
