class TargetLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double radius;

  const TargetLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.radius = 100,
  });
}

const targetLocations = [
  TargetLocation(
    id: 'shyamoli_square',
    name: 'Shyamoli Square Shopping Mall',
    latitude: 23.774082,
    longitude: 90.365210,
  ),
  TargetLocation(
    id: 'progressive_byte',
    name: 'Progressive Byte Ltd, Shyamoli',
    latitude: 23.77487430923034,
    longitude: 90.3678324945658,
  ),
  TargetLocation(
    id: 'adabor_thana',
    name: 'Adabor Thana',
    latitude: 23.770822,
    longitude: 90.357447,
  ),
  TargetLocation(
    id: 'pc_culture',
    name: 'PC Culture Housing, Mohammadpur',
    latitude: 23.763895,
    longitude: 90.358347,
  ),
];
