import 'dart:math';

int idGenerator() {
  final rnd = Random();
  final randomString =
      rnd.nextInt(999999).toString() +
      rnd.nextInt(999999).toString() +
      rnd.nextInt(99999).toString();

  return int.parse(randomString);
  //get a number from the list
}
