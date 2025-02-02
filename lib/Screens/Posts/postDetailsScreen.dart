import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Utils/utils.dart';

class PostDetailsScreen extends StatefulWidget {
  final String postId;
  PostDetailsScreen({required this.postId});

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  TextEditingController _answerController = TextEditingController();
  String? userRole;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  void _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userRole = userDoc['role'];
      });
    }
  }

  void _submitAnswer() async {
    String answer = _answerController.text.trim();
    if (answer.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc['role'] == 'muallim') {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .update({
          'answers': FieldValue.arrayUnion([
            {
              'answeredBy': userDoc['name'],
              'answer': answer,
            }
          ])
        });

        // Add the postId to the muallim's answeredPosts array
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'answeredPosts': FieldValue.arrayUnion([widget.postId]),
        });

        _answerController.clear();
        Utils().toastMessage('Answer submitted successfully');
      } else {
        Utils().toastMessage('Only Muallim can answer');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post Details',
          style: GoogleFonts.josefinSans(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var post = snapshot.data!;
          var answers = post['answers'] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(post['postContent'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                const Text('Answers:',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...answers.map((answer) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  child: ListTile(
                    title: Text(answer['answer']),
                    subtitle: Text('Answered by: ${answer['answeredBy']}'),
                  ),
                )),
                if (userRole == 'muallim')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _answerController,
                            decoration: const InputDecoration(
                                hintText: 'Enter your answer'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _submitAnswer,
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Only Muallim can answer posts.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:login_app/Utils/utils.dart';
//
// class PostDetailsScreen extends StatefulWidget {
//   final String postId;
//   PostDetailsScreen({required this.postId});
//
//   @override
//   _PostDetailsScreenState createState() => _PostDetailsScreenState();
// }
//
// class _PostDetailsScreenState extends State<PostDetailsScreen> {
//   TextEditingController _answerController = TextEditingController();
//   String? userRole;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserRole();
//   }
//
//   void _getUserRole() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//       setState(() {
//         userRole = userDoc['role'];
//       });
//     }
//   }
//
//   void _submitAnswer() async {
//     String answer = _answerController.text.trim();
//     if (answer.isNotEmpty) {
//       User? user = FirebaseAuth.instance.currentUser;
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user!.uid)
//           .get();
//
//       if (userDoc['role'] == 'muallim') {
//         await FirebaseFirestore.instance
//             .collection('posts')
//             .doc(widget.postId)
//             .update({
//           'answers': FieldValue.arrayUnion([
//             {
//               'answeredBy': userDoc['name'],
//               'answer': answer,
//             }
//           ])
//         });
//
//         _answerController.clear();
//         Utils().toastMessage('Answer submitted successfully');
//       } else {
//         Utils().toastMessage('Only Muallim can answer');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Post Details',
//           style: GoogleFonts.josefinSans(fontSize: 22),
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .doc(widget.postId)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           var post = snapshot.data!;
//           var answers = post['answers'] as List<dynamic>;
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     side: const BorderSide(color: Colors.grey, width: 1),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(post['postContent'],
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const Divider(),
//                 const Text('Answers:',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ...answers.map((answer) => Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         side: const BorderSide(color: Colors.grey, width: 1),
//                       ),
//                       child: ListTile(
//                         title: Text(answer['answer']),
//                         subtitle: Text('Answered by: ${answer['answeredBy']}'),
//                       ),
//                     )),
//                 if (userRole == 'muallim')
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _answerController,
//                             decoration: const InputDecoration(
//                                 hintText: 'Enter your answer'),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.send),
//                           onPressed: _submitAnswer,
//                         ),
//                       ],
//                     ),
//                   )
//                 else
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       'Only Muallim can answer posts.',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:login_app/Utils/utils.dart';
//
// class PostDetailsScreen extends StatefulWidget {
//   final String postId;
//   PostDetailsScreen({required this.postId});
//
//   @override
//   _PostDetailsScreenState createState() => _PostDetailsScreenState();
// }
//
// class _PostDetailsScreenState extends State<PostDetailsScreen> {
//   TextEditingController _answerController = TextEditingController();
//   String? userRole; // To store the user's role
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserRole(); // Fetch the user's role on screen initialization
//   }
//
//   // Function to retrieve user role from Firestore
//   void _getUserRole() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       setState(() {
//         userRole = userDoc['role']; // Set the role (either 'Muallim' or 'Student')
//       });
//     }
//   }
//
//   void _submitAnswer() async {
//     String answer = _answerController.text.trim();
//     if (answer.isNotEmpty) {
//       User? user = FirebaseAuth.instance.currentUser;
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
//
//       if (userDoc['role'] == 'Muallim') {
//         // Add the answer to the post in Firestore
//         await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
//           'answers': FieldValue.arrayUnion([{
//             'answeredBy': userDoc['name'],
//             'answer': answer,
//           }])
//         });
//
//         _answerController.clear();
//       } else {
//         Utils().toastMessage('Only Muallim can answer');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Post Details')),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           var post = snapshot.data!;
//           var answers = post['answers'] as List<dynamic>;
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(post['postContent'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ),
//               Divider(),
//               Text('Answers:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ...answers.map((answer) => ListTile(
//                 title: Text(answer['answer']),
//                 subtitle: Text('Answered by: ${answer['answeredBy']}'),
//               )),
//               if (userRole == 'Muallim') ...[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: _answerController,
//                     decoration: InputDecoration(hintText: 'Enter your answer'),
//                   ),
//                 ),
//                 ElevatedButton(onPressed: _submitAnswer, child: Text('Submit Answer')),
//               ]
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
