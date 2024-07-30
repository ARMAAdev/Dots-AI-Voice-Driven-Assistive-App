import 'package:dots/reader.dart';
import 'package:dots/settings.dart';
import 'package:dots/vision.dart';
import 'package:flutter/material.dart';
import 'package:dots/generated/l10n.dart';

class HomePageContent extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String apiKey; // Add this

  HomePageContent({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.apiKey, // Add this
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image.asset(
                      'images/dotsenglishicovector.png',
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: <Widget>[
              _buildGridico('braille3ico', S.of(context).BrailleTranslation, 87, 87),
              _buildGridItem(context, 'vision3ico', S.of(context).Vision, 90, 90),
              _buildGridItem(context, 'pictranslateico', 'PicTranslate', 97, 97),
              _buildGridico('echoico', 'Echo', 80, 80),
              _buildGridItem(context, 'settingsico', S.of(context).Settings, 75, 75),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String imageName, String label, double x, double y) {
    return InkWell(
      onTap: () {
        if (label == 'Vision') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VisionPage(apiKey: apiKey),
            ),
          );
        } else if (label == 'PicTranslate') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReaderPage(apiKey: apiKey),
            ),
          );
        }
    else if (label == S.of(context).Settings) {
    Navigator.of(context).push(
    MaterialPageRoute(
    builder: (context) => SettingsPage(),
    ),
    );
    }else {
    // Handle other item taps here, possibly using onItemTapped
    };
      },

      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: const Color.fromARGB(255, 232, 234, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(11),
              child: Image.asset(
                'images/$imageName.png',
                width: x,
                height: y,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'SF-Pro',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridico(String imageName, String label, double x, double y) {
    return InkWell(
      onTap: () {
        if (label == 'Braille Translation') {
          onItemTapped(1);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: const Color.fromARGB(255, 232, 234, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(11),
              child: Image.asset(
                'images/$imageName.png',
                width: x,
                height: y,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'SF-Pro',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
