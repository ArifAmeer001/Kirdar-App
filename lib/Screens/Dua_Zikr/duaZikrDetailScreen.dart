import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DuaZikrDetailScreen extends StatefulWidget {
  final String duaZikr;
  final String duaZikrArabic;

  DuaZikrDetailScreen({required this.duaZikr, required this.duaZikrArabic});

  @override
  _DuaZikrDetailScreenState createState() => _DuaZikrDetailScreenState();
}

class _DuaZikrDetailScreenState extends State<DuaZikrDetailScreen> {
  int count = 0; // Counter for Zikr/Dua repetitions

  void _incrementCounter() {
    setState(() {
      count++;
    });
  }

  Future<void> _saveCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Reference to the user's Firestore document
        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Fetch the current data
        DocumentSnapshot snapshot = await userDoc.get();

        // Define the new Dua/Zikr record
        final newDuaAndZikrRecord = {
          'duaZikr': widget.duaZikr,
          'count': count,
          'timestamp': DateTime.now().toIso8601String(), // Store timestamp as a string
        };

        if (snapshot.exists) {
          // Get the current data and safely cast it
          Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            // Extract existing DuaAndZikr history or initialize it
            List<dynamic> duaAndZikrHistory = (userData['History']?['DuaAndZikr'] ?? []) as List<dynamic>;

            // Check if the record already exists for the same Dua/Zikr
            bool alreadyExists = duaAndZikrHistory.any((record) =>
            record['duaZikr'] == widget.duaZikr &&
                DateTime.parse(record['timestamp']).day == DateTime.now().day);

            if (!alreadyExists) {
              // Add the new record to the history
              duaAndZikrHistory.add(newDuaAndZikrRecord);

              // Update the user's document
              await userDoc.update({
                'History.DuaAndZikr': duaAndZikrHistory,
                'score': FieldValue.increment(count),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Dua/Zikr saved successfully!")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Dua/Zikr already saved for today!")),
              );
            }
          }
        } else {
          // Create a new document with the Dua/Zikr record
          await userDoc.set({
            'History': {
              'DuaAndZikr': [newDuaAndZikrRecord],
            },
            'score': count,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Dua/Zikr saved successfully!")),
          );
        }

        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving Dua/Zikr: $e")),
        );
      }
    } else {
      // Handle unauthenticated user case
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.duaZikr,
          style: GoogleFonts.josefinSans(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.duaZikrArabic,
                style: GoogleFonts.scheherazadeNew(fontSize: 35, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _incrementCounter,
              child: CircleAvatar(
                backgroundColor: const Color(0xFF1C5153),
                radius: 80,
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveCount,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class DuaZikrDetailScreen extends StatefulWidget {
//   final String duaZikr;
//   final String duaZikrArabic;
//   DuaZikrDetailScreen({required this.duaZikr, required this.duaZikrArabic});
//
//   @override
//   _DuaZikrDetailScreenState createState() => _DuaZikrDetailScreenState();
// }
//
// class _DuaZikrDetailScreenState extends State<DuaZikrDetailScreen> {
//   int count = 0; // Counter for Zikr/Dua repetitions
//
//   void _incrementCounter() {
//     setState(() {
//       count++;
//     });
//   }
//
//   void _saveCount() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
//
//       DocumentSnapshot snapshot = await userDoc.get();
//
//       if (snapshot.exists) {
//         var userData = snapshot.data() as Map<String, dynamic>?; // Safely cast to a Map
//
//         if (userData != null && userData.containsKey('score')) {
//           // If the score field exists, add the current count to it
//           userDoc.update({
//             'score': FieldValue.increment(count),
//           });
//         } else {
//           // If the score field doesn't exist, create it and set the score
//           userDoc.set({
//             'score': count,
//           }, SetOptions(merge: true));
//         }
//       }
//     }
//     Navigator.pop(context); // Return to the previous screen after saving
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.duaZikr, style: GoogleFonts.josefinSans(fontSize: 22),), centerTitle: true,),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(widget.duaZikrArabic, style: GoogleFonts.scheherazadeNew(fontSize: 35, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 40),
//             GestureDetector(
//               onTap: _incrementCounter,
//               child: CircleAvatar(
//                 backgroundColor: const Color(0xFF1C5153),
//                 radius: 80,
//                 child: Text(
//                   count.toString(),
//                   style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: _saveCount,
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
