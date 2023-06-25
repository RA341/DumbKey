import 'dart:math';

int idGenerator({int length = 15}) {
  final rnd = Random();

  var randomNum = 0;
  var multiple = 1;
  for (var x = 1; x < length +1 ; x++) {
   randomNum += rnd.nextInt(9) * multiple;
   multiple *= 10;
  }

  return randomNum;
  //get a number from the list
}
