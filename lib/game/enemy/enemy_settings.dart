class EnemySettings {
  final String name;
  final Duration lifeTime;
  final double moveSpeed;
  final bool breaksOnAnyCollision;
  final int strength;
  final double width;
  final double height;

  const EnemySettings(
    this.name, {
    Duration? lifeTime,
    double? moveSpeed,
    bool? breaksOnAnyCollision,
    int? strength,
    double? width,
    double? height,
  })  : lifeTime = lifeTime ?? const Duration(seconds: 10),
        moveSpeed = moveSpeed ?? 700,
        breaksOnAnyCollision = breaksOnAnyCollision ?? false,
        strength = strength ?? 1,
        width = width ?? 10,
        height = height ?? 10;
}
