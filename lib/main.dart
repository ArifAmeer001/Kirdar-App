import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:login_app/Controllers/theme_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage and Firebase
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  tz.initializeTimeZones();

  // Request notification permission
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Initialize the ThemeController
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'Kirdar',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primaryColor: const Color(0xFF133D3E),
          hoverColor: const Color(0xFFF6AF58),
          scaffoldBackgroundColor: const Color(0xFF133D3E),
          textTheme: GoogleFonts.josefinSansTextTheme(
            ThemeData.light().textTheme.copyWith(
                  displayLarge: const TextStyle(
                    inherit: true,
                    fontFamily: 'JosefinSans',
                    fontSize: 57.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.3,
                    height: 1.1,
                  ),
                ),
          ),
          appBarTheme: const AppBarTheme(
            color: Color(0xFF133D3E),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          textTheme: GoogleFonts.josefinSansTextTheme(
            ThemeData.dark().textTheme.copyWith(
                  displayLarge: const TextStyle(
                    inherit: true,
                    fontFamily: 'JosefinSans',
                    fontSize: 57.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.3,
                    height: 1.1,
                  ),
                ),
          ),
          appBarTheme: const AppBarTheme(
            color: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.all(Colors.tealAccent),
            trackColor: MaterialStateProperty.all(Colors.teal[700]),
          ),
        ),

        // Theme mode dynamically determined
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

        // Home screen
        home: const SplashScreen(),
      ),
    );
  }
}
