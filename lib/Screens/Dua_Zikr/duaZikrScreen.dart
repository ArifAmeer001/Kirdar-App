import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Screens/Dua_Zikr/duaZikrDetailScreen.dart';
import 'notificationService.dart';

class DuaZikrScreen extends StatefulWidget {
  @override
  _DuaZikrScreenState createState() => _DuaZikrScreenState();
}

class _DuaZikrScreenState extends State<DuaZikrScreen> {
  final List<String> duasZikrEnglish = [
    "SubhanAllah",
    "Alhamdulillah",
    "Allahu Akbar",
    "Astaghfirullah",
  ];

  final List<String> duasZikrArabic = [
    "سُبْحَانَ ٱللَّٰهِ",
    "ٱلْحَمْدُ لِلَّٰهِ",
    "ٱللَّٰهُ أَكْبَرُ",
    "أَسْتَغْفِرُ ٱللَّٰهَ",
  ];

  final NotificationService _notificationService = NotificationService();

  void _showTimePickerDialog(BuildContext context, String duaZikr) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      final reminderTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final interval = reminderTime.difference(now);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reminder set for $duaZikr at ${selectedTime.format(context)}'),
      ));

      _notificationService.scheduleCustomNotification(
        "Reminder for $duaZikr",
        "It's time to recite $duaZikr.",
        interval,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Duas and Zikr', style: GoogleFonts.josefinSans(fontSize: 22)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: duasZikrEnglish.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.grey, width: 1),
              ),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(duasZikrEnglish[index]),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            duasZikrArabic[index],
                            style: GoogleFonts.scheherazadeNew(fontSize: 18, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DuaZikrDetailScreen(
                        duaZikr: duasZikrEnglish[index],
                        duaZikrArabic: duasZikrArabic[index],
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => _showTimePickerDialog(context, duasZikrEnglish[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}