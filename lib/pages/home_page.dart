import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.route, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 20),
            const Text(
              'No ongoing trip',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a trip from assigned job',
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
