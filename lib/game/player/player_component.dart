import 'dart:math';

import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';

class Player extends BodyComponent
    with KeyboardHandler, ContactCallbacks, HasGameRef<Forge2DGame> {
  final Map<LogicalKeyboardKey, bool> _pressedKeys = {
    LogicalKeyboardKey.keyW: false,
    LogicalKeyboardKey.keyA: false,
    LogicalKeyboardKey.keyS: false,
    LogicalKeyboardKey.keyD: false,
  };

  final BodyType _bodyType = BodyType.dynamic;
  final Vector2 _position;
  final double _radius = 10;
  final double _impulseForce = 10000;
  final int _maxHealth;

  int _health = 0;

  late final HellInSpaceGame hellGameRef;

  set health(int value) {
    if (value <= 0) {
      value = 0;
    } else {
      value = value > _maxHealth ? _maxHealth : value;
    }

    if (value != health) {
      _health = value;

      //TODO
      hellGameRef.playerBloc.add(PlayerHealthUpdated(_health));
    }
  }

  int get health => _health;

  Player(this._maxHealth, this._position, sprites)
      : super(renderBody: false, children: [
          _PlayerSpriteComponent(
              SpriteAnimation.spriteList(sprites, stepTime: 0.2)),
        ]) {
    _health = _maxHealth;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    hellGameRef = gameRef as HellInSpaceGame;
  }

  @override
  Body createBody() {
    final shape = CircleShape();
    shape.radius = _radius;

    final fixtureDef = FixtureDef(
      shape,
      friction: 1.0,
    );
    final bodyDef = BodyDef(
      position: _position,
      type: _bodyType,
      linearDamping: 0.6,
      userData: this,
    );

    final massData = MassData();
    massData.mass = 10;

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(massData);
  }

  @override
  void beginContact(Object other, Contact contact) {}

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    for (LogicalKeyboardKey key in _pressedKeys.keys) {
      _pressedKeys[key] = keysPressed.contains(key);
    }

    if (keysPressed.contains(LogicalKeyboardKey.minus)) {
      health--;
    } else if (keysPressed.contains(LogicalKeyboardKey.add)) {
      health++;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    Vector2 direction = Vector2.zero();

    if (_pressedKeys[LogicalKeyboardKey.keyW]!) {
      direction.y -= 1;
    }

    if (_pressedKeys[LogicalKeyboardKey.keyS]!) {
      direction.y += 1;
    }

    if (_pressedKeys[LogicalKeyboardKey.keyA]!) {
      direction.x -= 1;
    }

    if (_pressedKeys[LogicalKeyboardKey.keyD]!) {
      direction.x += 1;
    }

    body.applyLinearImpulse(direction * _impulseForce * dt);

    double targetAngle =
        atan2(body.linearVelocity.y, body.linearVelocity.x) + (0.5 * pi);

    body.setTransform(body.position, targetAngle);
    body.angularVelocity = 0;

    super.update(dt);
  }
}

class _PlayerSpriteComponent extends SpriteAnimationComponent {
  _PlayerSpriteComponent(SpriteAnimation animation)
      : super(
          animation: animation,
          anchor: Anchor.center,
        );
}
