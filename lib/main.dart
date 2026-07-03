import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import 'config/api.dart';
import 'pages/home_page.dart';
import 'pages/journey_page.dart';
import 'pages/mark_pickup.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _restoreTripIfExists();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) {
      _handleUri(uri);
    }

    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    });
  }

  Future<void> _handleUri(Uri uri) async {
    final token = uri.queryParameters['token'];
    if (token == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_trip_token', token);

    _navigateFromToken(token);
  }

  Future<void> _restoreTripIfExists() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('active_trip_token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      _navigateFromToken(token);
    }
  }

  Future<void> _navigateFromToken(String token) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final decoded = JwtDecoder.decode(token);

      final bidNo = decoded['bidNo'].toString();
      final from = decoded['from'];
      final to = decoded['to'];

      final url = ApiConfig.tripStatus(bidNo);

      try {
        final response = await http.get(
          url,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        );

        final body = jsonDecode(response.body);

        if (response.statusCode != 200 || body["success"] != true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('active_trip_token');

          navKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (_) => false,
          );
          return;
        }

        final status = body["status"].toString().toLowerCase();

        if (status == "awaiting pickup") {
          navKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => MarkPickupPage(bidNo: bidNo, from: from, to: to),
            ),
            (_) => false,
          );
        } else if (status == "in transit") {
          navKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => JourneyPage(bidNo: bidNo, from: from, to: to),
            ),
            (_) => false,
          );
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('active_trip_token');

          navKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (_) => false,
          );
        }
      } catch (e) {
        print("ERROR CALLING BACKEND: $e");

        navKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (_) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
