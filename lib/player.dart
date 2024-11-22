import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';

class Player extends BodyComponent with KeyboardHandler {
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

  Player(this._position, sprite)
      : super(renderBody: false, children: [
          _PlayerSpriteComponent(sprite),
        ]);

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
    );

    final massData = MassData();
    massData.mass = 10;

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(massData);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    for (LogicalKeyboardKey key in _pressedKeys.keys) {
      _pressedKeys[key] = keysPressed.contains(key);
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

    double targetAngle = atan2(body.linearVelocity.y, body.linearVelocity.x) +
        (0.5 * pi);

    body.setTransform(body.position, targetAngle);
    body.angularVelocity = 0;

    super.update(dt);
  }
}

class _PlayerSpriteComponent extends SpriteComponent {
  _PlayerSpriteComponent(sprite) : super(anchor: Anchor.center, sprite: sprite);
}
