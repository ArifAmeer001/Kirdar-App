import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_app/Auth/loginScreen.dart';
import 'package:login_app/Utils/utils.dart';

class RoleSelectionScreen extends StatefulWidget {
  final User? user;
  final String name; // Add this to accept the name
  RoleSelectionScreen({required this.user, required this.name});

  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    print("Name passed to RoleSelectionScreen: ${widget.name}"); // Debugging
  }

  void saveUserRole() async {
    if (selectedRole != null && widget.user != null) {
      FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).set({
        'name': widget.name, // Use the name passed from SignupScreen
        'email': widget.user!.email,
        'role': selectedRole,
        'score': 50,
        if (selectedRole == 'student') 'posts': {'answered': null},
        if (selectedRole == 'muallim') 'posts': {'answered': null, 'answeredPosts': []},
      }, SetOptions(merge: true));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      Utils().toastMessage('Please select a Role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Role')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Student'),
              leading: Radio<String>(
                value: 'student',
                groupValue: selectedRole,
                onChanged: (String? value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Muallim'),
              leading: Radio<String>(
                value: 'muallim',
                groupValue: selectedRole,
                onChanged: (String? value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: saveUserRole,
              child: Text('Save Role'),
            ),
          ],
        ),
      ),
    );
  }
}



// class RoleSelectionScreen extends StatefulWidget {
//   final User? user;
//   final String name; // Add this to accept the name
//   RoleSelectionScreen({required this.user, required this.name});
//
//   @override
//   _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
// }
//
// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//
//   void saveUserRole() async {
//     if (selectedRole != null && widget.user != null) {
//       // Save user data in Firestore
//       FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).set({
//         'name': widget.name, // Use the name passed from SignupScreen
//         'email': widget.user!.email,
//         'role': selectedRole,
//         'score': 50,
//         if (selectedRole == 'student') 'posts': {'answered': null},
//         if (selectedRole == 'muallim') 'posts': {'answered': null, 'answeredPosts': []},
//       }, SetOptions(merge: true));
//
//       // Navigate to login screen after saving the role
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//     } else {
//       Utils().toastMessage('Please select a Role');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select Role')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ListTile(
//               title: const Text('Student'),
//               leading: Radio<String>(
//                 value: 'student',
//                 groupValue: selectedRole,
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedRole = value;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               title: const Text('Muallim'),
//               leading: Radio<String>(
//                 value: 'muallim',
//                 groupValue: selectedRole,
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedRole = value;
//                   });
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: saveUserRole,
//               child: Text('Save Role'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// class RoleSelectionScreen extends StatefulWidget {
//   final User? user;
//   const RoleSelectionScreen(this.user, {super.key});
//
//   @override
//   _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
// }
//
// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//
//   Future<void> saveUserRole() async {
//     if (selectedRole != null && widget.user != null) {
//       try {
//         final userCollection = FirebaseFirestore.instance.collection('users');
//
//         // Build initial data structure
//         Map<String, dynamic> userData = {
//           'email': widget.user!.email,
//           'role': selectedRole,
//           'name': widget.user!.displayName ?? 'User', // Use name provided during signup
//           'score': 50, // Default score
//           'posts': [], // List of posts created by the user
//         };
//
//         // Role-specific fields
//         if (selectedRole == 'student') {
//           userData['answered'] = null; // Student has `answered` set to null
//         } else if (selectedRole == 'muallim') {
//           userData['answered'] = []; // Muallim has a list for answered posts
//         }
//
//         // Save to Firestore
//         await userCollection.doc(widget.user!.uid).set(userData, SetOptions(merge: true));
//
//         Utils().toastMessage('Role saved successfully');
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//         );
//       } catch (error) {
//         Utils().toastMessage('Error saving role: $error');
//       }
//     } else {
//       Utils().toastMessage('Please select a Role');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Select Role')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ListTile(
//               title: const Text('Student'),
//               leading: Radio<String>(
//                 value: 'student',
//                 groupValue: selectedRole,
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedRole = value;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               title: const Text('Muallim'),
//               leading: Radio<String>(
//                 value: 'muallim',
//                 groupValue: selectedRole,
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedRole = value;
//                   });
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: saveUserRole,
//               child: const Text('Save Role'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:login_app/Auth/loginScreen.dart';
// import 'package:login_app/Utils/utils.dart';
//
// class RoleSelectionScreen extends StatefulWidget {
//   final User? user;
//   RoleSelectionScreen(this.user);
//
//   @override
//   _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
// }
//
// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//
//   void saveUserRole() async {
//     if (selectedRole != null && widget.user != null) {
//       FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).set({
//         'email': widget.user!.email,
//         'role': selectedRole,
//       },  SetOptions(merge: true));
//       // Navigate to login screen after saving the role
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//     } else {
//       Utils().toastMessage('Please select a Role');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select Role')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ListTile(
//               title: const Text('Student'),
//               leading: Radio<String>(
//                 value: 'student',
//                 groupValue: selectedRole,
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedRole = value;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               title: const Text('Muallim'),
//               leading: Radio<String>(
//                 value: 'muallim',
//                 groupValue: selectedRole,
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedRole = value;
//                   });
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: saveUserRole,
//               child: Text('Save Role'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
