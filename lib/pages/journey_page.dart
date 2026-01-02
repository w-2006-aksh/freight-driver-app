import 'package:flutter/material.dart';
import 'package:gps_locator/pages/otp_page.dart';
import '@/../../services/location_services.dart';
import 'dart:async';

class JourneyPage extends StatefulWidget {
  final String bidNo;
  final String from;
  final String to;
  const JourneyPage({
    super.key,
    required this.bidNo,
    required this.from,
    required this.to,
  });

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    sendLocation(widget.bidNo);
    _locationTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => sendLocation(widget.bidNo),
    );
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Mark as delivered?'),
                    content: const Text('Is the package delivered?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtpPage(bidNo: widget.bidNo),
                            ),
                          );
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue[500],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(7),
                  right: Radius.circular(7),
                ),
              ),
            ),
            child: const Text(
              'Mark as Delivered',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),

            const Text(
              "Current Trip",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text('Trip #${widget.bidNo}', style: const TextStyle(fontSize: 18)),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    "Route",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _cityBox(widget.from),
                      const Icon(Icons.arrow_forward, size: 25),
                      _cityBox(widget.to),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            const TripInTransitAnimation(),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _cityBox(String city) {
    return Text(
      city,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }
}

class TripInTransitAnimation extends StatefulWidget {
  const TripInTransitAnimation({super.key});

  @override
  State<TripInTransitAnimation> createState() => TripInTransitAnimationState();
}

class TripInTransitAnimationState extends State<TripInTransitAnimation> {
  bool visible = true;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      if (!mounted) return false;
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        visible = !visible;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0.4,
      duration: const Duration(milliseconds: 800),
      child: Text(
        'In transit...',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey[700],
        ),
      ),
    );
  }
}
