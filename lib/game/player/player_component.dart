import 'dart:developer';

import 'package:dutch_game_studio_assessment/game/mixins/has_hell_in_space_game_ref.dart';
import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';

class Player extends BodyComponent
    with Steering, KeyboardHandler, HasHellInSpaceGameRef {
  final Map<LogicalKeyboardKey, bool> _pressedKeys = {
    LogicalKeyboardKey.keyW: false,
    LogicalKeyboardKey.keyA: false,
    LogicalKeyboardKey.keyS: false,
    LogicalKeyboardKey.keyD: false,
  };

  late final _PlayerSpriteComponent _spriteComponent;

  final BodyType _bodyType = BodyType.dynamic;
  final Vector2 _position;
  final double _radius = 10;

  int _health = 0;

  double _timeSinceLastHit = 0;
  bool _invincibilityActive = false;

  int get health => _health;

  set health(int value) {
    if (value <= 0) {
      value = 0;
    } else {
      value = value > GameSettings.maxPlayerHealth
          ? GameSettings.maxPlayerHealth
          : value;
    }

    _health = value;
    hellInSpaceGameRef.playerBloc.add(PlayerHealthUpdated(_health));
  }

  Player(this._position, sprites)
      : super(renderBody: false, children: [
          _PlayerSpriteComponent(
              SpriteAnimation.spriteList(sprites, stepTime: 0.2))
        ]) {
    _spriteComponent = children.first as _PlayerSpriteComponent;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _health = GameSettings.maxPlayerHealth;
    hellInSpaceGameRef.playerBloc.add(PlayerHealthUpdated(_health));
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
    _timeSinceLastHit += dt;

    if (_invincibilityActive) {
      if (_timeSinceLastHit >= GameSettings.invincibilityDuration) {
        _invincibilityActive = false;
        _spriteComponent.disableInvincibilityEffect();
      }
    }

    Vector2 direction = getSteeringDirection(
      upPressed: _pressedKeys[LogicalKeyboardKey.keyW]!,
      downPressed: _pressedKeys[LogicalKeyboardKey.keyS]!,
      leftPressed: _pressedKeys[LogicalKeyboardKey.keyA]!,
      rightPressed: _pressedKeys[LogicalKeyboardKey.keyD]!,
    );

    body.applyLinearImpulse(direction * GameSettings.playerMoveSpeed * dt);
    handleRotation(body);
    super.update(dt);
  }

  void hit(int strength) {
    if (_timeSinceLastHit >= GameSettings.invincibilityDuration) {
      health -= strength;

      _invincibilityActive = true;
      _spriteComponent.enableInvincibilityEffect();

      hellInSpaceGameRef.startScreenShake(GameSettings.invincibilityDuration.toInt());

      _timeSinceLastHit = 0;
    }
  }
}

class _PlayerSpriteComponent extends SpriteAnimationComponent {
  _PlayerSpriteComponent(SpriteAnimation animation)
      : super(
          animation: animation,
          anchor: Anchor.center,
        );

  void enableInvincibilityEffect() {
    decorator.addLast(PaintDecorator.tint(const Color.fromARGB(180, 255, 1, 1)));
  }

  void disableInvincibilityEffect() {
    decorator.removeLast();
  }
}
