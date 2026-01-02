import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Position> getCurrentLocation() async {
  await Geolocator.requestPermission();
  return await Geolocator.getCurrentPosition(
    locationSettings: AndroidSettings(accuracy: LocationAccuracy.low),
  );
}

const List<Map<String, double>> dummyLocations = [
  {"lat": 28.6139, "lng": 77.2090},
  {"lat": 28.6139, "lng": 77.2090},

  {"lat": 26.9124, "lng": 75.7873},

  {"lat": 26.9124, "lng": 75.7873},

  {"lat": 23.0225, "lng": 72.5714},

  {"lat": 19.0760, "lng": 72.8777},
];

int _dummyIndex = 0;

Future<void> sendLocation(String bidNo) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("active_trip_token");
  if (token == null) return;

  final location = dummyLocations[_dummyIndex];
  _dummyIndex = (_dummyIndex + 1) % dummyLocations.length;

  print("SENDING DUMMY LOCATION: $location");

  await http.post(
    Uri.parse("http://172.20.10.3:8000/api/trip/update-location/$bidNo"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({"lat": location["lat"], "lng": location["lng"]}),
  );
}

// Future<void> sendLocation(String bidNo) async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString("active_trip_token");
//   if (token == null) return;

//   final pos = await getCurrentLocation();

//   await http.post(
//     Uri.parse("http://172.20.10.3:8000/api/trip/update-location/$bidNo"),
//     headers: {
//       "Authorization": "Bearer $token",
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode({"lat": pos.latitude, "lng": pos.longitude}),
//   );
// }
