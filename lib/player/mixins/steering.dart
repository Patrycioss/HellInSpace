part of '../player_component.dart';

mixin _Steering on BodyComponent {
  Vector2 getSteeringDirection({
    upPressed = false,
    downPressed = false,
    leftPressed = false,
    rightPressed = false,
  }) {
    Vector2 direction = Vector2.zero();

    if (upPressed) {
      direction.y -= 1;
    }

    if (downPressed) {
      direction.y += 1;
    }

    if (leftPressed) {
      direction.x -= 1;
    }

    if (rightPressed) {
      direction.x += 1;
    }
    return direction;
  }

  void handleRotation(Body body) {
    double targetAngle =
        atan2(body.linearVelocity.y, body.linearVelocity.x) + (0.5 * pi);

    body.setTransform(body.position, targetAngle);
    body.angularVelocity = 0;
  }
}
