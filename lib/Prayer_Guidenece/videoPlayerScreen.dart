import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  const VideoPlayerScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Auto-play video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? GestureDetector(
        onTap: _toggleControls, // Toggle controls visibility
        child: Stack(
          children: [
            // Video Player
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),

            // Controls Overlay
            if (_isControlsVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54, // Semi-transparent background
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.blue,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildControlButton(
                            icon: Icons.slow_motion_video,
                            label: "0.5x",
                            onPressed: () {
                              _controller.setPlaybackSpeed(0.5);
                            },
                          ),
                          _buildControlButton(
                            icon: _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            label: _controller.value.isPlaying ? "Pause" : "Play",
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                          ),
                          _buildControlButton(
                            icon: Icons.speed,
                            label: "1.5x",
                            onPressed: () {
                              _controller.setPlaybackSpeed(1.5);
                            },
                          ),
                          _buildControlButton(
                            icon: Icons.fast_forward,
                            label: "2x",
                            onPressed: () {
                              _controller.setPlaybackSpeed(2.0);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoPath;
//   const VideoPlayerScreen({Key? key, required this.videoPath}) : super(key: key);
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool _isError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset(widget.videoPath)
//       ..initialize().then((_) {
//         setState(() {});
//       }).catchError((error) {
//         setState(() {
//           _isError = true;
//         });
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isError) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Video Player')),
//         body: const Center(
//           child: Text(
//             'Failed to load video.',
//             style: TextStyle(color: Colors.red, fontSize: 18),
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Player')),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             ),
//             const SizedBox(height: 10),
//             VideoProgressIndicator(
//               _controller,
//               allowScrubbing: true,
//               colors: const VideoProgressColors(
//                 playedColor: Colors.blue,
//                 bufferedColor: Colors.grey,
//                 backgroundColor: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       if (_controller.value.isPlaying) {
//                         _controller.pause();
//                       } else {
//                         _controller.play();
//                       }
//                     });
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.fast_forward),
//                   onPressed: () => _controller.setPlaybackSpeed(1.5),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.slow_motion_video),
//                   onPressed: () => _controller.setPlaybackSpeed(0.5),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.speed),
//                   onPressed: () => _controller.setPlaybackSpeed(2.0),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.speed_outlined),
//                   onPressed: () => _controller.setPlaybackSpeed(1.0),
//                 ),
//               ],
//             ),
//           ],
//         )
//             : const CircularProgressIndicator(),
//       ),
//     );
//   }
// }