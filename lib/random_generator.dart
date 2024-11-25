import 'dart:math';

class RandomGenerator {
  static RandomGenerator? _instance;
  static bool _instantiated = false;

  final Random _random = Random();

  RandomGenerator get() {
    if (!_instantiated) {
      _instance = RandomGenerator();
      _instantiated = true;
    }

    return _instance!;
  }

  Random get random => _random;
}
