import 'package:flutter/material.dart';
import 'package:gps_locator/pages/journey_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MarkPickupPage extends StatefulWidget {
  final String bidNo, from, to;
  const MarkPickupPage({
    super.key,
    required this.bidNo,
    required this.from,
    required this.to,
  });

  @override
  State<MarkPickupPage> createState() => _MarkPickupPageState();
}

class _MarkPickupPageState extends State<MarkPickupPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Awaiting Pickup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bid #${widget.bidNo}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text("From: ${widget.from}"),
            Text("To: ${widget.to}"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.black87,
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Mark pick up?"),
                            content: const Text("Mark package as picked up?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                 
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final token = prefs.getString(
                                    'active_trip_token',
                                  );

                                  if (token == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Session expired. Please open the link again.",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final url = Uri.parse(
                                    "http://172.20.10.3:8000/api/trip/mark-as-picked/${widget.bidNo}",
                                  );

                                  try {
                                    final response = await http.post(
                                      url,
                                      headers: {
                                        "Content-Type": "application/json",
                                        "Authorization": "Bearer $token",
                                      },
                                    );

                                    final data = jsonDecode(response.body);

                                    if (response.statusCode == 200 &&
                                        data["success"] == true) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => JourneyPage(
                                            bidNo: widget.bidNo,
                                            from: widget.from,
                                            to: widget.to,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Pickup marking failed. Try again.",
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Network error: $e"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Mark Pickup",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
