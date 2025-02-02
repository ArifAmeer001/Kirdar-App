import 'package:flutter/material.dart';
import 'package:login_app/Halal_Food/halalFoodCheckerScreen.dart';
import 'package:login_app/Halal_Food/halalRestaurantScreen.dart';
class HalalFoodScreen extends StatelessWidget {
  const HalalFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Halal Food Checker Section
            const Text(
              "Check Halal Status for Food",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Halal Food Checker Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HalalFoodCheckerScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF133D3E),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Check Halal Food"),
            ),
            const SizedBox(height: 40),

            // Restaurant Locator Section
            const Text(
              "Find Nearby Halal Restaurants",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Restaurant Locator Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HalalRestaurantScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF133D3E),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Locate Halal Restaurants"),
            ),
          ],
        ),
      ),
    );
  }
}
