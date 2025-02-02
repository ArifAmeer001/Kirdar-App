import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _postController = TextEditingController();

  void _submitPost() async {
    String postContent = _postController.text.trim();
    if (postContent.isNotEmpty) {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

      // Check if the user is a student
      if (userDoc['role'] == 'student') {
        // Generate a unique ID for the post
        DocumentReference newPost = FirebaseFirestore.instance.collection('posts').doc();

        // Add the post to Firestore under the student's 'posts'
        await newPost.set({
          'postContent': postContent,
          'createdBy': userDoc['name'], // Fetch user's name from the document
          'createdAt': FieldValue.serverTimestamp(),
          'answers': []
        });

        // Optionally add post ID to the user's record under 'posts'
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'posts': FieldValue.arrayUnion([newPost.id])
        });

        Navigator.pop(context); // Go back to the posts screen
      } else {
        // If user is muallim, show error (you can add this part for clarity)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Muallims can create and answer posts.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ask your Question', style: GoogleFonts.josefinSans(fontSize: 22),), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.grey, width: 1),
            ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _postController,
                  maxLines: 7,
                  decoration: const InputDecoration(hintText: 'Enter your question here',),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: const Text('Submit Post'),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class CreatePostScreen extends StatefulWidget {
//   @override
//   _CreatePostScreenState createState() => _CreatePostScreenState();
// }
//
// class _CreatePostScreenState extends State<CreatePostScreen> {
//   TextEditingController _postController = TextEditingController();
//
//   void _submitPost() async {
//     String postContent = _postController.text.trim();
//     if (postContent.isNotEmpty) {
//       // Get the current user
//       User? user = FirebaseAuth.instance.currentUser;
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
//
//       // Generate a unique ID for the post
//       DocumentReference newPost = FirebaseFirestore.instance.collection('posts').doc();
//
//       // Add the post to Firestore
//       await newPost.set({
//         'postContent': postContent,
//         'createdBy': userDoc['name'], // Fetch user's name from the document
//         'createdAt': FieldValue.serverTimestamp(),
//         'answers': []
//       });
//
//       // Optionally add post ID to the user's record
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//         'posts': FieldValue.arrayUnion([{
//           'postID': newPost.id,
//           'post': postContent,
//         }])
//       });
//
//       Navigator.pop(context); // Go back to the posts screen
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Ask your Question', style: GoogleFonts.josefinSans(fontSize: 22),), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Card(shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               side: const BorderSide(color: Colors.grey, width: 1),
//             ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 child: TextField(
//                   controller: _postController,
//                   maxLines: 7,
//                   decoration: const InputDecoration(hintText: 'Enter your question here',),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitPost,
//               child: const Text('Submit Post'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
