import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hell_in_space/sound/sound_helper.dart';

import '../game_settings.dart';
import '../mixins/has_hell_in_space_game_ref.dart';
import 'bloc/player_bloc.dart';

part 'state/player_state.dart';

part 'state/invulnerable_player_state.dart';

part 'state/regular_player_state.dart';

part 'mixins/steering.dart';

class Player extends BodyComponent with _Steering, HasHellInSpaceGameRef {
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

  late final SpriteAnimationComponent _animationComponent;
  final Vector2 _initialPosition;
  _PlayerState _activeState = _RegularPlayerState();
  int _health = 0;

  Player(this._initialPosition, sprites)
      : super(renderBody: false, children: [
          SpriteAnimationComponent(
              anchor: Anchor.center,
              animation: SpriteAnimation.spriteList(sprites, stepTime: 0.2))
        ]) {
    _animationComponent = children.first as SpriteAnimationComponent;
  }

  Future<void> hit(int strength) async {
    if (_activeState.canBeHit) {
      _setState(
          _InvulnerablePlayerState(() => _setState(_RegularPlayerState())));
      health -= strength;

      hellInSpaceGameRef.startScreenShake(GameSettings.screenShakeDuration);

      await SoundHelper.playSound(GameSettings.hitSoundPath);

      add(
        ParticleSystemComponent(
          particle: CircleParticle(
            radius: 30,
            paint: Paint()..color = Colors.yellow.withOpacity(.5),
          ),
        ),
      );
    }
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
    shape.radius = GameSettings.playerHitBoxRadius;

    final fixtureDef = FixtureDef(
      shape,
      friction: 1.0,
    );
    final bodyDef = BodyDef(
      position: _initialPosition,
      type: BodyType.dynamic,
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
  void update(double dt) {
    var input = hellInSpaceGameRef.inputManager;

    if (input.isKeyDown(LogicalKeyboardKey.minus)) {
      health--;
    } else if (input.isKeyDown(LogicalKeyboardKey.add)) {
      health++;
    }

    Vector2 direction = getSteeringDirection(
      upPressed: input.isActionPressed("move_up"),
      downPressed: input.isActionPressed("move_down"),
      leftPressed: input.isActionPressed("move_left"),
      rightPressed: input.isActionPressed("move_right"),
    );

    body.applyLinearImpulse(direction * GameSettings.playerMoveSpeed * dt);
    handleRotation(body);
    super.update(dt);
  }

  void _setState(_PlayerState state) {
    _activeState.stop(this);
    _activeState = state;
    _activeState.start(this);
  }
}
