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
    name: 'Shyamoli Square footover bridge',
    latitude: 23.77460,
    longitude: 90.36576,
  ),
  TargetLocation(
    id: 'progressive_byte',
    name: 'Progressive Byte Ltd, Shyamoli',
    latitude: 23.77476,
    longitude: 90.36768,
  ),
  TargetLocation(
    id: 'shymloi_road_1',
    name: 'Shymoli road 1 to Shymoli square',
    latitude: 23.77503,
    longitude: 90.36660,
  ),
  TargetLocation(
    id: 'pc_culture',
    name: 'PC Culture Housing, Mohammadpur',
    latitude: 23.763895,
    longitude: 90.358347,
  ),

  TargetLocation(
    id: 'swapna_neer',
    name: 'You are near swapna neer',
    latitude: 23.768956620455896,
    longitude: 90.35918222825141,
  ),

  TargetLocation(
    id: 'mosque',
    name: 'You are in Baitus Salah Jameh mosjid, Ring Road',
    latitude: 23.769651103838626,
    longitude: 90.3588346391626,
  ),

  TargetLocation(
    id: 'school',
    name: 'You are near Dhaka Central International School',
    latitude: 23.77344880857213,
    longitude: 90.36115599767813,
  ),

  TargetLocation(
    id: "agargao",
    name: "You are near Agargao Metro station",
    latitude: 23.777349999982384,
    longitude: 90.38034937010679,
  ),

  TargetLocation(
    id: "investment",
    name: "You are near Bangladesh Investment Development Authority",
    latitude: 23.776336024899976,
    longitude: 90.37762085286451,
  ),
];
