import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Assets/quranMap.dart';
import 'package:login_app/Screens/Quran_Screens/surahDetailScreen.dart';
import 'package:quran/quran.dart' as quran;

class QuranScreen extends StatefulWidget {
  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<String> filteredSurahNames = surahNames.where((surah) {
      return surah.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Quran', style: GoogleFonts.josefinSans(fontSize: 22),), centerTitle: true,),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Surah',
                  border: OutlineInputBorder(
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSurahNames.length,
                itemBuilder: (context, index) {
                  String surahName = filteredSurahNames[index];
                  int surahNumber = surahNameToIndex[surahName]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: MouseRegion(
                      onEnter: (_) => setState(() {}),
                      onExit: (_) => setState(() {}),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(color: Colors.grey, width: 1),
                        ),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                surahName,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                quran.getSurahNameArabic(surahNumber),
                                style: GoogleFonts.scheherazadeNew( fontSize: 18),
                              )
                            ],
                          ),
                          subtitle: Text("Surah $surahNumber"),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Place of Revelation: ${quran.getPlaceOfRevelation(surahNumber)}\n'
                                    'Total Ayats: ${quran.getVerseCount(surahNumber)}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SurahDetailScreen(
                                      surahName: surahName,
                                      surahNumber: surahNumber,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Go to Surah'),
                            ),
                            const SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// class QuranScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Quran')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Search Surah',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   // Update state based on search query
//                 },
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: surahNames.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(surahNames[index]),
//                     onTap: () {
//                       // Navigate to the detail screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SurahDetailScreen(
//                             surahName: surahNames[index],
//                             surahNumber: surahNameToIndex[surahNames[index]]!,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
