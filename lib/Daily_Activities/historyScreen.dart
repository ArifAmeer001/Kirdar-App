import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> combinedHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final user = _auth.currentUser;

    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14));

        List<Map<String, dynamic>> history = [];

        // Fetch Namaz history
        final namazHistory = userData?['History']?['Namazs'] as List<dynamic>? ?? [];
        for (var record in namazHistory) {
          final timestamp = _parseTimestamp(record['timestamp']);
          if (timestamp != null && timestamp.isAfter(twoWeeksAgo)) {
            history.add({
              'type': 'Namaz',
              'name': record['namazType'],
              'details': "Option: ${record['option']}",
              'timestamp': timestamp,
            });
          }
        }

        // Fetch Dua/Zikr history
        final duaZikrHistory = userData?['History']?['DuaAndZikr'] as List<dynamic>? ?? [];
        for (var record in duaZikrHistory) {
          final timestamp = _parseTimestamp(record['timestamp']);
          if (timestamp != null && timestamp.isAfter(twoWeeksAgo)) {
            history.add({
              'type': 'Dua/Zikr',
              'name': record['duaZikr'],
              'details': "Count: ${record['count']}",
              'timestamp': timestamp,
            });
          }
        }

        // Sort history by timestamp (descending)
        history.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        setState(() {
          combinedHistory = history;
        });
      }
    }
  }

  /// Helper function to parse timestamps
  DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return null; // Return null if parsing fails
      }
    }
    return null; // Return null for unsupported types
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: combinedHistory.isEmpty
            ? const Center(
          child: Text("No history found for the last 2 weeks."),
        )
            : ListView.builder(
          itemCount: combinedHistory.length,
          itemBuilder: (context, index) {
            final record = combinedHistory[index];
            final formattedDate = DateFormat.yMMMEd().format(record['timestamp']);
            final formattedTime = DateFormat.jm().format(record['timestamp']);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CircleAvatar(
                    child: Text(record['type'][0]), // N for Namaz, D for Dua/Zikr
                  ),
                ),
                title: Text(
                  record['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "${record['details']}\nDate: $formattedDate\nTime: $formattedTime"),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }
//
// class _HistoryScreenState extends State<HistoryScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   List<Map<String, dynamic>> history = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchHistory();
//   }
//
//   Future<void> _fetchHistory() async {
//     final user = _auth.currentUser;
//
//     if (user != null) {
//       final userDoc = _firestore.collection('users').doc(user.uid);
//
//       final userSnapshot = await userDoc.get();
//       if (userSnapshot.exists) {
//         final historyData = userSnapshot.data()?['History']?['Namazs'] as List<dynamic>? ?? [];
//
//         // Filter records from the last 2 weeks
//         final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14));
//         final recentHistory = historyData
//             .where((record) {
//           final recordDate = DateTime.fromMillisecondsSinceEpoch(record['timestamp'].millisecondsSinceEpoch).toLocal();
//           return recordDate.isAfter(twoWeeksAgo);
//         })
//             .map((record) => {
//           'namazType': record['namazType'],
//           'option': record['option'],
//           'timestamp': DateTime.fromMillisecondsSinceEpoch(record['timestamp'].millisecondsSinceEpoch).toLocal(),
//         })
//             .toList();
//
//         setState(() {
//           history = recentHistory;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("History"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: history.isEmpty
//             ? const Center(
//           child: Text("No history found for the last 2 weeks."),
//         )
//             : ListView.builder(
//           itemCount: history.length,
//           itemBuilder: (context, index) {
//             final record = history[index];
//             final formattedDate = DateFormat.yMMMEd().format(record['timestamp']);
//             final formattedTime = DateFormat.jm().format(record['timestamp']);
//
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8.0),
//               child: ListTile(
//                 title: Text(
//                   record['namazType'],
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text("Option: ${record['option']}\nDate: $formattedDate\nTime: $formattedTime"),
//                 isThreeLine: true,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
