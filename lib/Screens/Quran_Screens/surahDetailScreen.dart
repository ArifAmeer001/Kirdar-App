import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Utils/utils.dart';
import 'package:quran/quran.dart' as quran;

class SurahDetailScreen extends StatefulWidget {
  final String surahName;
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahName, required this.surahNumber});

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final _startAyatController = TextEditingController();
  final _endAyatController = TextEditingController();
  Timer? _scoreTimer;
  int? _startAyat;
  int? _endAyat;
  final int _scoreIncrement = 10;
  bool _showTranslation = false;
  List<String> _translations = [];
  double _defaultFontSize = 18.0;

  final TransformationController _transformationController = TransformationController();
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _startScoreTimer();
  }

  @override
  void dispose() {
    _scoreTimer?.cancel();
    _startAyatController.dispose();
    _endAyatController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _startScoreTimer() {
    _scoreTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _updateScore();
    });
  }

  void _updateScore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot snapshot = await userDoc.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('score')) {
          userDoc.update({'score': FieldValue.increment(_scoreIncrement)});
        } else {
          userDoc.set({'score': _scoreIncrement}, SetOptions(merge: true));
        }
      }
      Utils().toastMessage('Score updated by $_scoreIncrement');
    }
  }

  void _validateAndSetAyats() {
    final int surahVerseCount = quran.getVerseCount(widget.surahNumber);

    int? startAyatInput = int.tryParse(_startAyatController.text);
    int? endAyatInput = int.tryParse(_endAyatController.text);

    startAyatInput = startAyatInput ?? 1;
    endAyatInput = endAyatInput ?? surahVerseCount;

    if (startAyatInput < 1 || startAyatInput > surahVerseCount) {
      Utils().toastMessage('Start Ayat must be between 1 and $surahVerseCount');
      return;
    }

    if (endAyatInput < 1 || endAyatInput > surahVerseCount) {
      Utils().toastMessage('End Ayat must be between 1 and $surahVerseCount');
      return;
    }

    if (startAyatInput > endAyatInput) {
      Utils().toastMessage('Start Ayat cannot be greater than End Ayat');
      return;
    }

    setState(() {
      _startAyat = startAyatInput;
      _endAyat = endAyatInput;
      _showTranslation = false; // Reset translation visibility
    });
  }

  Future<void> _loadTranslation() async {
    if (_startAyat != null && _endAyat != null) {
      _translations = [];
      for (int i = _startAyat!; i <= _endAyat!; i++) {
        _translations.add(quran.getVerseTranslation(widget.surahNumber, i, translation: quran.Translation.enSaheeh));
      }
      setState(() => _showTranslation = true);
    }
  }

  void _handleDoubleTap() {
    setState(() {
      if (_currentScale == 1.0) {
        _currentScale = 2.0;
      } else if (_currentScale == 2.0) {
        _currentScale = 3.0;
      } else {
        _currentScale = 1.0;
      }
      _transformationController.value = Matrix4.identity()..scale(_currentScale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surahName,
          style: GoogleFonts.josefinSans(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                quran.getSurahNameArabic(widget.surahNumber),
                style: GoogleFonts.scheherazadeNew(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startAyatController,
                      decoration: const InputDecoration(
                        labelText: 'Start Ayat',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _endAyatController,
                      decoration: const InputDecoration(
                        labelText: 'End Ayat',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: _validateAndSetAyats,
              child: const Text('Show Surah'),
            ),
            ElevatedButton(
              onPressed: _startAyat != null && _endAyat != null ? _loadTranslation : null,
              child: const Text('Show Translation'),
            ),
            Expanded(
              child: GestureDetector(
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  boundaryMargin: const EdgeInsets.all(16),
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Container(
                    color: backgroundColor,
                    child: ListView.builder(
                      itemCount: _startAyat != null && _endAyat != null ? (_endAyat! - _startAyat! + 1) : 0,
                      itemBuilder: (context, index) {
                        int ayatNumber = _startAyat! + index;
                        return ListTile(
                          title: Text(
                            quran.getVerse(widget.surahNumber, ayatNumber, verseEndSymbol: true),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: _defaultFontSize, color: textColor),
                          ),
                          subtitle: _showTranslation && index < _translations.length
                              ? Text(_translations[index], style: TextStyle(color: textColor))
                              : null,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// class SurahDetailScreen extends StatefulWidget {
//   final String surahName;
//   final int surahNumber;
//
//   const SurahDetailScreen({super.key, required this.surahName, required this.surahNumber});
//
//   @override
//   _SurahDetailScreenState createState() => _SurahDetailScreenState();
// }
//
// class _SurahDetailScreenState extends State<SurahDetailScreen> {
//   final _startAyatController = TextEditingController();
//   final _endAyatController = TextEditingController();
//   Timer? _scoreTimer;
//   int? _startAyat;
//   int? _endAyat;
//   final int _scoreIncrement = 10;
//   bool _showTranslation = false;
//   List<String> _translations = [];
//   double _defaultFontSize = 18.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _startScoreTimer();
//   }
//
//   @override
//   void dispose() {
//     _scoreTimer?.cancel();
//     _startAyatController.dispose();
//     _endAyatController.dispose();
//     super.dispose();
//   }
//
//   void _startScoreTimer() {
//     _scoreTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
//       _updateScore();
//     });
//   }
//
//   void _updateScore() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
//       DocumentSnapshot snapshot = await userDoc.get();
//
//       if (snapshot.exists) {
//         final data = snapshot.data() as Map<String, dynamic>?;
//         if (data != null && data.containsKey('score')) {
//           userDoc.update({'score': FieldValue.increment(_scoreIncrement)});
//         } else {
//           userDoc.set({'score': _scoreIncrement}, SetOptions(merge: true));
//         }
//       }
//       Utils().toastMessage('Score updated by $_scoreIncrement');
//     }
//   }
//
//   void _validateAndSetAyats() {
//     final int surahVerseCount = quran.getVerseCount(widget.surahNumber);
//
//     int? startAyatInput = int.tryParse(_startAyatController.text);
//     int? endAyatInput = int.tryParse(_endAyatController.text);
//
//     // If inputs are null or empty, set defaults
//     startAyatInput = startAyatInput ?? 1;
//     endAyatInput = endAyatInput ?? surahVerseCount;
//
//     if (startAyatInput < 1 || startAyatInput > surahVerseCount) {
//       Utils().toastMessage('Start Ayat must be between 1 and $surahVerseCount');
//       return;
//     }
//
//     if (endAyatInput < 1 || endAyatInput > surahVerseCount) {
//       Utils().toastMessage('End Ayat must be between 1 and $surahVerseCount');
//       return;
//     }
//
//     if (startAyatInput > endAyatInput) {
//       Utils().toastMessage('Start Ayat cannot be greater than End Ayat');
//       return;
//     }
//
//     setState(() {
//       _startAyat = startAyatInput;
//       _endAyat = endAyatInput;
//       _showTranslation = false; // Reset translation visibility
//     });
//   }
//
//   Future<void> _loadTranslation() async {
//     if (_startAyat != null && _endAyat != null) {
//       _translations = [];
//       for (int i = _startAyat!; i <= _endAyat!; i++) {
//         _translations.add(quran.getVerseTranslation(widget.surahNumber, i, translation: quran.Translation.enSaheeh));
//       }
//       setState(() => _showTranslation = true);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final backgroundColor = isDarkMode ? Colors.black : Colors.white;
//     final textColor = isDarkMode ? Colors.white : Colors.black;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.surahName,
//           style: GoogleFonts.josefinSans(fontSize: 22),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 quran.getSurahNameArabic(widget.surahNumber),
//                 style: GoogleFonts.scheherazadeNew(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _startAyatController,
//                       decoration: const InputDecoration(
//                         labelText: 'Start Ayat',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: TextField(
//                       controller: _endAyatController,
//                       decoration: const InputDecoration(
//                         labelText: 'End Ayat',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 5),
//             ElevatedButton(
//               onPressed: _validateAndSetAyats,
//               child: const Text('Show Surah'),
//             ),
//             ElevatedButton(
//               onPressed: _startAyat != null && _endAyat != null ? _loadTranslation : null,
//               child: const Text('Show Translation'),
//             ),
//             Expanded(
//               child: _startAyat != null && _endAyat != null
//                   ? InteractiveViewer(
//                 boundaryMargin: const EdgeInsets.all(16),
//                 minScale: 1.0,
//                 maxScale: 4.0,
//                 child: Container(
//                   color: backgroundColor,
//                   child: ListView.builder(
//                     itemCount: (_endAyat! - _startAyat! + 1),
//                     itemBuilder: (context, index) {
//                       int ayatNumber = _startAyat! + index;
//                       return ListTile(
//                         title: Text(
//                           quran.getVerse(widget.surahNumber, ayatNumber, verseEndSymbol: true),
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontSize: _defaultFontSize, color: textColor),
//                         ),
//                         subtitle: _showTranslation && _translations.length > index
//                             ? Text(_translations[index], style: TextStyle(color: textColor))
//                             : null,
//                       );
//                     },
//                   ),
//                 ),
//               )
//                   : const Center(child: Text('Enter a valid range to display the Ayats')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:login_app/Utils/utils.dart';
// import 'package:quran/quran.dart' as quran;
// import 'package:zoom_widget/zoom_widget.dart';
//
// class SurahDetailScreen extends StatefulWidget {
//   final String surahName;
//   final int surahNumber;
//
//   const SurahDetailScreen({super.key, required this.surahName, required this.surahNumber});
//
//   @override
//   _SurahDetailScreenState createState() => _SurahDetailScreenState();
// }
//
// class _SurahDetailScreenState extends State<SurahDetailScreen> {
//   final _startAyatController = TextEditingController();
//   final _endAyatController = TextEditingController();
//   Timer? _scoreTimer;
//   int? _startAyat;
//   int? _endAyat;
//   final int _scoreIncrement = 10;
//   bool _showTranslation = false;
//   List<String> _translations = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _startScoreTimer();
//   }
//
//   @override
//   void dispose() {
//     _scoreTimer?.cancel();
//     _startAyatController.dispose();
//     _endAyatController.dispose();
//     super.dispose();
//   }
//
//   void _startScoreTimer() {
//     _scoreTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
//       _updateScore();
//     });
//   }
//
//   void _updateScore() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
//       DocumentSnapshot snapshot = await userDoc.get();
//
//       if (snapshot.exists) {
//         final data = snapshot.data() as Map<String, dynamic>?;
//         if (data != null && data.containsKey('score')) {
//           userDoc.update({'score': FieldValue.increment(_scoreIncrement)});
//         } else {
//           userDoc.set({'score': _scoreIncrement}, SetOptions(merge: true));
//         }
//       }
//       Utils().toastMessage('Score updated by $_scoreIncrement');
//     }
//   }
//
//   void _validateAndSetAyats() {
//     final int surahVerseCount = quran.getVerseCount(widget.surahNumber);
//
//     int? startAyatInput = int.tryParse(_startAyatController.text);
//     int? endAyatInput = int.tryParse(_endAyatController.text);
//
//     // If inputs are null or empty, set defaults
//     startAyatInput = startAyatInput ?? 1;
//     endAyatInput = endAyatInput ?? surahVerseCount;
//
//     if (startAyatInput < 1 || startAyatInput > surahVerseCount) {
//       Utils().toastMessage('Start Ayat must be between 1 and $surahVerseCount');
//       return;
//     }
//
//     if (endAyatInput < 1 || endAyatInput > surahVerseCount) {
//       Utils().toastMessage('End Ayat must be between 1 and $surahVerseCount');
//       return;
//     }
//
//     if (startAyatInput > endAyatInput) {
//       Utils().toastMessage('Start Ayat cannot be greater than End Ayat');
//       return;
//     }
//
//     setState(() {
//       _startAyat = startAyatInput;
//       _endAyat = endAyatInput;
//       _showTranslation = false; // Reset translation visibility
//     });
//   }
//
//   Future<void> _loadTranslation() async {
//     if (_startAyat != null && _endAyat != null) {
//       _translations = [];
//       for (int i = _startAyat!; i <= _endAyat!; i++) {
//         _translations.add(quran.getVerseTranslation(widget.surahNumber, i, translation: quran.Translation.enSaheeh));
//       }
//       setState(() => _showTranslation = true);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.surahName,
//           style: GoogleFonts.josefinSans(fontSize: 22),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 quran.getSurahNameArabic(widget.surahNumber),
//                 style: GoogleFonts.scheherazadeNew(fontSize: 24, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _startAyatController,
//                       decoration: const InputDecoration(
//                         labelText: 'Start Ayat',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: TextField(
//                       controller: _endAyatController,
//                       decoration: const InputDecoration(
//                         labelText: 'End Ayat',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 5),
//             ElevatedButton(
//               onPressed: _validateAndSetAyats,
//               child: const Text('Show Surah'),
//             ),
//             ElevatedButton(
//               onPressed: _startAyat != null && _endAyat != null ? _loadTranslation : null,
//               child: const Text('Show Translation'),
//             ),
//             Expanded(
//               child: _startAyat != null && _endAyat != null
//                   ? ListView.builder(
//                 itemCount: _endAyat! - _startAyat! + 1,
//                 itemBuilder: (context, index) {
//                   int ayatNumber = _startAyat! + index;
//                   return ListTile(
//                     title: Text(
//                       quran.getVerse(widget.surahNumber, ayatNumber, verseEndSymbol: true),
//                       textAlign: TextAlign.right,
//                     ),
//                     subtitle: _showTranslation ? Text(_translations[index]) : null,
//                   );
//                 },
//               )
//                   : const Center(child: Text('Enter a valid range to display the Ayats')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }