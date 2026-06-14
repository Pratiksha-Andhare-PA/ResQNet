import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map hospital;

  const ConfirmationScreen({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmed")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),

            Text(
              "Hospital Selected Successfully",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text("🏥 ${hospital["name"]}"),
            Text("📍 ${hospital["distance"]} km away"),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                // future: tracking screen
              },
              child: const Text("Track Ambulance"),
            ),
          ],
        ),
      ),
    );
  }
}
