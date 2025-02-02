import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Auth/loginScreen.dart';
import 'package:login_app/Controllers/theme_controller.dart';
import 'package:login_app/Screens/Posts/postDetailsScreen.dart';
import 'package:login_app/Screens/Profile/circularProgressWidget.dart';
import 'package:login_app/Utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  String? userName, email, role;
  int score = 0;
  List<String> userQuestions = []; // List of post IDs for the user
  final ThemeController _themeController = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    var currentUser = auth.currentUser;
    if (currentUser != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      setState(() {
        userName = userDoc.get('name');
        email = userDoc.get('email');
        role = userDoc.get('role');
        score = userDoc.get('score');
        print('User Data: $userName, $email, $role, $score'); // Debugging log

        // Handling posts for Student and Muallim differently
        if (role == 'student') {
          var posts = List<String>.from(userDoc.get('posts')); // Student posts
          print('Student Posts: $posts'); // Debugging log
          userQuestions = posts;
        } else if (role == 'muallim') {
          var posts = userDoc.get('posts'); // Muallim posts are stored as a map
          var answeredPosts = List<String>.from(userDoc.get('answeredPosts')); // Muallim answered posts
          print('Muallim Posts: $posts'); // Debugging log
          print('Muallim Answered Posts: $answeredPosts'); // Debugging log

          // For Muallim, we need to combine answeredPosts with posts (if any)
          // Even if there are no posts, answeredPosts can still have answered questions.
          userQuestions = answeredPosts.isNotEmpty ? answeredPosts : [];
        }
      });
      print('userQuestions: $userQuestions'); // Debugging log
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: GoogleFonts.josefinSans(fontSize: 22),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                });
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(userName ?? '',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(email ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Role: ${role ?? ''}',
                      style: const TextStyle(fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 20),
                  CircularProgressWidget(score: score),
                  const SizedBox(height: 20),
                  // Theme toggle tile
                  GestureDetector(
                    onTap: () {
                      _themeController.toggleTheme();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _themeController.isDarkMode.value
                            ? Colors.black54
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: _themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _themeController.isDarkMode.value
                                ? 'Dark Mode'
                                : 'Light Mode',
                            style: GoogleFonts.josefinSans(
                                fontSize: 16,
                                color: _themeController.isDarkMode.value
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Your Questions',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: userQuestions.isEmpty
                        ? const Center(child: Text('No posts available'))
                        : ListView.builder(
                      itemCount: userQuestions.length,
                      itemBuilder: (context, index) {
                        var postId = userQuestions[index];
                        print('Fetching post for ID: $postId'); // Debugging log
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailsScreen(
                                  postId: postId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.teal[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(postId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Error fetching post'));
                                } else if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return const Center(
                                      child: Text('Post not found'));
                                }

                                var postData = snapshot.data!.data()
                                as Map<String, dynamic>;
                                print('Post Data: $postData'); // Debugging log
                                return Text(
                                  postData['postContent'] ?? 'No content',
                                  style: GoogleFonts.josefinSans(
                                      fontSize: 16, color: Colors.black87),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}