import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_app/Daily_Activities/DailyActivitiesScreen.dart';
import 'package:login_app/Halal_Food/halalFoodScreen.dart';
import 'package:login_app/Map/mapScreen.dart';
import 'package:login_app/Screens/Dua_Zikr/duaZikrScreen.dart';
import 'package:login_app/Screens/Posts/postsScreen.dart';
import 'package:login_app/Screens/Profile/profileScreen.dart';
import 'package:login_app/Screens/commingSoonScreen.dart';
import 'package:login_app/Screens/Quran_Screens/quranScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      var currentUser = auth.currentUser;
      if (currentUser != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            userName = userDoc.get('name') ?? 'Unknown'; // Fallback to 'Unknown'
          });
        } else {
          print("User document does not exist or is empty.");
          setState(() {
            userName = 'Unknown';
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        userName = 'Error';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFF133D3E),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                stretch: true,
                expandedHeight: 120.0,
                backgroundColor: const Color(0xFF133D3E),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProfileScreen()));
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                'https://tse3.mm.bing.net/th?id=OIP.jOt-AtLvj6y2XpzzLjohXAHaHa&pid=Api&P=0&h=220'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Assalam o Alikum',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.lightBackgroundGray),
                            ),
                            Text(
                              userName ?? 'Fetching...',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: CupertinoColors.lightBackgroundGray),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      //this is for card
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.19,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF6AF58),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Remember Allah',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.black)),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Start Daily\n Activities',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.black,
                                          fontWeight: FontWeight.bold)),
                                  ElevatedButton(
                                      onPressed: () {
                                        //place your logic here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(
                                            0xFF133D3E), // foreground
                                      ),
                                      child: const Text("Get Started"))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // // Add more widgets here
                    const SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height / 2 + 10,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(40.0)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            //this is for   6 containers
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD2CFCF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DuaZikrScreen()));
                                            },
                                            child: Image.asset(
                                              'assets/image2.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const Text(
                                            'Duas &',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text('Zikr',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD2CFCF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MapScreen()
                                                      // ComingSoonScreen()
                                                      ));
                                            },
                                            child: Image.asset(
                                              'assets/image3.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const Text(
                                            'Mosque',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text('Locator',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD2CFCF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DailyActivitiesScreen()));
                                            },
                                            child: Image.asset(
                                              'assets/image4.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const Text(
                                            '   Daily \n Activities',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          //   Text('Locator',style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD2CFCF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QuranScreen()));
                                            },
                                            child: Image.asset(
                                              'assets/image5.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const Text(
                                            'Quranic',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text('Reciatation',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD2CFCF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HalalFoodScreen()));
                                            },
                                            child: Image.asset(
                                              'assets/image6.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const Text(
                                            'Halal Foods',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          //  Text('Reciatation',style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD2CFCF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PostsScreen()));
                                            },
                                            child: Image.asset(
                                              'assets/image7.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const Text(
                                            'Q/A',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          //  Text('Reciatation',style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFFDFD),
                                  border: Border.all(
                                    color: const Color(0xFF133D3E),
                                    width: 1,
                                  )),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFF5D8082),
                                    ),
                                    onPressed: () {},
                                    child: const SizedBox(
                                      width: 200, // Adjust the width as needed
                                      // height: 10, // Adjust the height as needed
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Center the content
                                        children: [
                                          Icon(Icons.location_on),
                                          SizedBox(
                                              width:
                                                  8), // Add some spacing between the icon and text
                                          Text(
                                            'Abbottabad Pakistan',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //list of all containers
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF133D3E),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .14,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "04:36",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ComingSoonScreen()));
                                              },
                                              child: Image.asset(
                                                'assets/mosque1.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Fajar",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF133D3E),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .14,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "12:24",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ComingSoonScreen()));
                                              },
                                              child: Image.asset(
                                                'assets/mosque1.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Dzuhur",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF133D3E),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .14,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "15:24",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ComingSoonScreen()));
                                              },
                                              child: Image.asset(
                                                'assets/mosque1.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Asar",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF133D3E),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .14,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "18:17",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ComingSoonScreen()));
                                              },
                                              child: Image.asset(
                                                'assets/mosque1.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Magrib",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF133D3E),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .14,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "19:29",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ComingSoonScreen()));
                                              },
                                              child: Image.asset(
                                                'assets/mosque1.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Esha",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    // Add other widgets as needed
                  ],
                ),
              )
            ],
          )),
    );
  }
}
