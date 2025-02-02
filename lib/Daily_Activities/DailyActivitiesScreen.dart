import 'package:flutter/material.dart';
import 'package:login_app/Prayer_Guidenece/namazGuidanceScreen.dart';
import 'package:login_app/Daily_Activities/Namaz/namazTab.dart';
import 'package:login_app/Daily_Activities/historyScreen.dart';

class DailyActivitiesScreen extends StatelessWidget {
  const DailyActivitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Activities'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.grey, width: 1),
              ),
              child: ListTile(
                leading: const Icon(Icons.access_time, size: 40, color: Colors.blue),
                title: const Text('Namaz'),
                subtitle: const Text('Record your daily prayers'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NamazTab()),
                  );
                },
              ),
            ),
            const Divider(),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.grey, width: 1),
              ),
              child: ListTile(
                leading: const Icon(Icons.video_collection, size: 40, color: Colors.purple),
                title: const Text('Namaz Guidance'),
                subtitle: const Text('Learn how to perform Namaz'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NamazGuidanceScreen()),
                  );
                },
              ),
            ),
            const Divider(),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.grey, width: 1),
              ),
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.blue),
                title: const Text("History"),
                subtitle: const Text('Track your Kirdar History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}