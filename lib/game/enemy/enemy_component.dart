import 'dart:async' as async;

import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Enemy extends BodyComponent
    with HasGameRef<Forge2DGame>, ContactCallbacks {
  final Vector2 _position;
  final EnemySettings _settings;
  final EnemyMoveBehaviour _moveBehaviour;

  late final HellInSpaceGame _hellInSpaceGame;

  late final async.Timer _lifeTimeTimer;

  Enemy(this._position, this._settings, this._moveBehaviour)
      : super(renderBody: false, children: [
          RectangleComponent(
            size: Vector2(_settings.width, _settings.height),
          )
        ]) {
    _lifeTimeTimer = async.Timer(_settings.lifeTime, destroy);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _hellInSpaceGame = gameRef as HellInSpaceGame;
  }

  @override
  void update(double dt) {
    _moveBehaviour.handleMovement(dt, body, _hellInSpaceGame.player, _settings);
    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (_settings.breaksOnAnyCollision) {
      destroy();
    } else if (other is Player) {
      other.health -= _settings.strength;
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
      position: _position,
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

  void destroy() {
    _lifeTimeTimer.cancel();
    removeFromParent();
  }
}
