import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../helper.dart';
import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

final Helper helper = Helper();
DateTime _dateTime = DateTime.now();

class Functional {
  void sendLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("id");
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);

    // mendapatkan alamat
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var alamat = addresses.first;

    // print(alamat.addressLine.toString());
    final response = await http.post(Config.BASE_URL + "sendLocation", body: {
      "id": userId,
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "currentloc": alamat.addressLine.toString(),
      "update_lokasi_at": _dateTime.toString()
    });
    final res = jsonDecode(response.body);
    // print(res);
    if (res['status'] == 200) {
      // print("Lokasi Petugas saat ini : $position");
      getDistance(position.latitude, position.latitude);
    } else {
      print("Gagal mendapatkan lokasi");
    }
  }

  getDistance(double userLat, double userLong) async {
    final response = await http.post(Config.BASE_URL + "getLokasiKantor");
    final res = jsonDecode(response.body);
    double officeLat = double.parse(res['latitude']);
    double officeLong = double.parse(res['longitude']);
    print(res);
    Future<double> distanceInMeters =
        Geolocator().distanceBetween(userLat, officeLat, userLong, officeLong);
    return distanceInMeters;
  }
}
