import 'package:geocoding/geocoding.dart';

import '../../constants.dart';

Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      double latitude = locations[0].latitude;
      double longitude = locations[0].longitude;

      return {'latitude': latitude, 'longitude': longitude};
    }
    return null;
  } catch (e) {
    logger.e('Error occurred: $e');
    return null;
  }
}
