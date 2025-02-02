import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Screens/Posts/createPostScreen.dart';
import 'package:login_app/Screens/Posts/postDetailsScreen.dart';

class PostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Questions', style: GoogleFonts.josefinSans(fontSize: 22),), centerTitle: true,),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Card(shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Colors.grey, width: 1),
                ),
                  child: ListTile(
                    title: Text(post['postContent']),
                    subtitle: Text('Created by: ${post['createdBy']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostDetailsScreen(postId: post.id)),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1C5153),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
        child: const Icon(Icons.send, color: Colors.white,),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:login_app/Screens/Posts/createPostScreen.dart';
// import 'package:login_app/Screens/Posts/postDetailsScreen.dart';
//
// class PostsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Questions', style: GoogleFonts.josefinSans(fontSize: 22),), centerTitle: true,),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('posts').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           var posts = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: posts.length,
//             itemBuilder: (context, index) {
//               var post = posts[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 child: Card(shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   side: const BorderSide(color: Colors.grey, width: 1),
//                 ),
//                   child: ListTile(
//                     title: Text(post['postContent']),
//                     subtitle: Text('Created by: ${post['createdBy']}'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => PostDetailsScreen(postId: post.id)),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF1C5153),
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostScreen()));
//         },
//         child: const Icon(Icons.send, color: Colors.white,),
//       ),
//     );
//   }
// }
