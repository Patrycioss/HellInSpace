import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Enemy extends BodyComponent{

  final BodyType _bodyType = BodyType.dynamic;
  final Vector2 _position;
  final double _radius = 10;

  Enemy(this._position)
    : super(renderBody: false, children: [
      RectangleComponent(
        size: Vector2(10,10)
      )
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
      userData: this,
    );

    final massData = MassData();
    massData.mass = 10;

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(massData);
  }
}