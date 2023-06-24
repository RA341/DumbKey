import 'dart:math';

int idGenerator({int length = 20}) {
  final rnd = Random();
  final g = Iterable.generate(
    length,
    (_) => rnd.nextInt(
      rnd.nextInt(1000000000),
    ),
  ).join();

  return int.tryParse(g)!;
  //get a number from the list
}
