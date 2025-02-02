import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NamazActivities {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> recordNamaz({
    required String namazType,
    required String option,
    required DateTime timestamp,
  }) async {
    final user = _auth.currentUser;

    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);

      // Fetch the current history
      final userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        final history = userSnapshot.data()?['History']?['Namazs'] as List<dynamic>? ?? [];

        // Check if the Namaz record already exists for the same day
        final existingRecord = history.firstWhere(
              (record) =>
          record['namazType'] == namazType &&
              DateTime.fromMillisecondsSinceEpoch(record['timestamp'].millisecondsSinceEpoch)
                  .toLocal()
                  .difference(timestamp)
                  .inDays ==
                  0,
          orElse: () => null,
        );

        if (existingRecord != null) {
          // Duplicate record found, prevent storage
          print('Duplicate entry: $namazType has already been recorded for today.');
          return;
        }
      }

      // Add new Namaz record
      await userDoc.set({
        'History': {
          'Namazs': FieldValue.arrayUnion([
            {
              'namazType': namazType,
              'option': option,
              'timestamp': timestamp,
            }
          ]),
        }
      }, SetOptions(merge: true));

      print('$namazType successfully recorded.');
    }
  }
}
