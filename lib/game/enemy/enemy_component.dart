import 'dart:async' as async;
import 'dart:developer' as dev;

import 'package:dutch_game_studio_assessment/game/component_pool.dart';
import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Enemy extends BodyComponent
    with HasGameRef<Forge2DGame>, ContactCallbacks
    implements Resettable {
  final EnemySettings _settings;
  final EnemyMoveBehaviour _moveBehaviour;
  final void Function(Enemy enemy) _onDestroyCallback;

  late HellInSpaceGame _hellInSpaceGame;
  late async.Timer _lifeTimeTimer;
  Vector2 _startPosition;

  Enemy(this._startPosition, this._settings, this._moveBehaviour,
      this._onDestroyCallback)
      : super(renderBody: false);

  @override
  void onMount() {
    super.onMount();
    if (!world.physicsWorld.bodies.contains(body)){
      body = createBody();
    }

    _hellInSpaceGame = gameRef as HellInSpaceGame;
    _lifeTimeTimer = async.Timer(_settings.lifeTime, destroy);

    add(RectangleComponent(
      size: Vector2(_settings.width, _settings.height),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _moveBehaviour.handleMovement(dt, body, _hellInSpaceGame.player, _settings);
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
    removeAll(children);
  }

  void destroy() {
    _onDestroyCallback(this);
  }

  setPosition(Vector2 decidePosition) {
    _startPosition = decidePosition;
  }
}
