import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  late LocationData _locationData;

  Future<void> initialize() async {
    bool serviceEnabled;
    PermissionStatus permission;

    serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if(!serviceEnabled) {
        return;
      }
    }

    permission = await location.hasPermission();
    if(permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    if(permission != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<double?> getLatitude() async {
    _locationData = await location.getLocation();
    return _locationData.latitude;
  }

  Future<double?> getLongitude() async {
    _locationData = await location.getLocation();
    return _locationData.longitude;
  }
}