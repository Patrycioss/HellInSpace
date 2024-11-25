import 'dart:async' as async;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../behaviours/enemy/enemy_move_behaviour.dart';
import '../mixins/has_hell_in_space_game_ref.dart';
import '../player/player_component.dart';
import '../utils/resettable.dart';
import 'enemy_settings.dart';

class Enemy extends BodyComponent
    with HasHellInSpaceGameRef, ContactCallbacks
    implements Resettable {
  final EnemySettings _settings;
  final EnemyMoveBehaviour _moveBehaviour;
  final void Function(Enemy enemy) _onDestroyCallback;

  Vector2 _startPosition;

  Enemy(this._startPosition, this._settings, this._moveBehaviour,
      this._onDestroyCallback)
      : super(renderBody: false);

  setPosition(Vector2 decidePosition) {
    _startPosition = decidePosition;
  }

  @override
  void onMount() {
    super.onMount();
    if (!world.physicsWorld.bodies.contains(body)) {
      body = createBody();
    }

    async.Timer(_settings.lifeTime, destroy);

    add(RectangleComponent(
      size: Vector2(_settings.width, _settings.height),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _moveBehaviour.handleMovement(
        dt, body, hellInSpaceGameRef.player, _settings);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (_settings.breaksOnAnyCollision) {
      destroy();
    } else if (other is Player) {
      other.hit(_settings.strength);
      destroy();
    }
  }

  @override
  Body createBody() {
    final shape = PolygonShape();

    shape.setAsBox(
        _settings.width / 2.0, _settings.height / 2.0, Vector2(0, 0), 0);

    final fixtureDef = FixtureDef(
      shape,
      friction: 1.0,
    );
    final bodyDef = BodyDef(
      position: _startPosition,
      type: BodyType.dynamic,
      linearDamping: 0.6,
      userData: this,
      bullet: true,
    );

    final massData = MassData();
    massData.mass = 10;

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(massData);
  }

  @override
  void reset() {
    removeFromParent();
    // removeAll(children);
  }

  void destroy() {
    _onDestroyCallback(this);
  }
}
