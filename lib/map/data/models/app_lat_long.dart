class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });
}

class TashkentLocation extends AppLatLong {
  // 41.3068697,69.228153
  const TashkentLocation({
    super.long = 69.228153,
    super.lat = 41.3068697,
  });
}