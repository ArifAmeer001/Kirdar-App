import 'package:flutter/material.dart';
import 'VideoPlayerScreen.dart';

class NamazGuidanceScreen extends StatelessWidget {
  const NamazGuidanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final videos = [
      {'title': 'Kirrat', 'path': 'assets/Animations/kirrat.mp4'},
      {'title': 'Rukku', 'path': 'assets/Animations/rukku.mp4'},
      {'title': 'Rukku Baad', 'path': 'assets/Animations/rukku_baad.mp4'},
      {'title': 'Sajjda', 'path': 'assets/Animations/sajjda.mp4'},
      {'title': 'Qadda', 'path': 'assets/Animations/qadda.mp4'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Guidance Videos'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.play_circle_fill, color: Color(0xFF133D3E)),
                title: Text(video['title']!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(videoPath: video['path']!),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
