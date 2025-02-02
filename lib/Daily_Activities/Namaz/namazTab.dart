import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_app/Daily_Activities/Namaz/namazActivities.dart';

class NamazTab extends StatelessWidget {
  const NamazTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Namaz Categories'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Farz'),
              Tab(text: 'Nafil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FarzTab(),
            NafilTab(),
          ],
        ),
      ),
    );
  }
}

class FarzTab extends StatelessWidget {
  final Map<String, Map<String, String>> timeFrames = {
    'Fajr': {'start': '05:00', 'end': '06:30'},
    'Zuhr': {'start': '12:30', 'end': '13:30'},
    'Asr': {'start': '15:30', 'end': '17:00'},
    'Maghrib': {'start': '17:30', 'end': '18:30'},
    'Isha': {'start': '19:30', 'end': '20:30'},
  };

  bool _isWithinTimeFrame(String namaz, TimeOfDay currentTime) {
    final start = TimeOfDay(
      hour: int.parse(timeFrames[namaz]!['start']!.split(':')[0]),
      minute: int.parse(timeFrames[namaz]!['start']!.split(':')[1]),
    );
    final end = TimeOfDay(
      hour: int.parse(timeFrames[namaz]!['end']!.split(':')[0]),
      minute: int.parse(timeFrames[namaz]!['end']!.split(':')[1]),
    );

    final nowMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  void _recordNamaz(BuildContext context, String namaz, String option) {
    final now = DateTime.now();
    NamazActivities().recordNamaz(namazType: namaz, option: option, timestamp: now).then((_) {
      Fluttertoast.showToast(
        msg: 'Recorded $namaz as $option successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Error recording Namaz: $error',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: timeFrames.keys.length,
      itemBuilder: (context, index) {
        final namaz = timeFrames.keys.elementAt(index);
        final now = TimeOfDay.fromDateTime(DateTime.now());
        final isWithinTime = _isWithinTimeFrame(namaz, now);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
          child: Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.grey, width: 1),
              ),
              title: Text(namaz),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Qazza' || isWithinTime) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Record $namaz'),
                        content: Text('Are you sure you want to record $namaz as $value?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _recordNamaz(context, namaz, value);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: '$namaz is only available as Qazza outside the time frame.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'BaJamaat',
                      enabled: isWithinTime,
                      child: const Text('BaJamaat'),
                    ),
                    PopupMenuItem(
                      value: 'Individual',
                      enabled: isWithinTime,
                      child: const Text('Individual'),
                    ),
                    const PopupMenuItem(
                      value: 'Qazza',
                      child: Text('Qazza'),
                    ),
                  ];
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class NafilTab extends StatelessWidget {
  final List<String> nafilNamazs = ['Tahajjud', 'Awabeen', 'Ishraaq', 'Chaasht'];

  void _recordNamaz(BuildContext context, String namaz) {
    final now = DateTime.now();
    NamazActivities().recordNamaz(namazType: namaz, option: 'Individual', timestamp: now).then((_) {
      Fluttertoast.showToast(
        msg: 'Recorded $namaz successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Error recording Namaz: $error',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nafilNamazs.length,
      itemBuilder: (context, index) {
        final namaz = nafilNamazs[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.grey, width: 1),
            ),
            child: ListTile(
              title: Text(namaz),
              trailing: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Record $namaz'),
                      content: const Text('Are you sure you want to record this Namaz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _recordNamaz(context, namaz);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Record'),
              ),
            ),
          ),
        );
      },
    );
  }
}
