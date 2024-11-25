import 'dart:math';

class RandomGenerator {
  Random get random => _random;

  static RandomGenerator? _instance;
  static bool _instantiated = false;

  final Random _random = Random();

  static RandomGenerator get() {
    if (!_instantiated) {
      _instance = RandomGenerator();
      _instantiated = true;
    }

    return _instance!;
  }
}
