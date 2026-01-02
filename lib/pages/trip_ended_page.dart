import 'package:flutter/material.dart';
import '@/../home_page.dart';

class TripEndedPage extends StatelessWidget {
  const TripEndedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Trip Completed",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Thank you"),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
                ;
              },
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
