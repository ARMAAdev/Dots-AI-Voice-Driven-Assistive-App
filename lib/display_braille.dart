import 'package:dots/settings.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:dots/generated/l10n.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'History.dart';
import 'home_page.dart';

class DisplayTranslation extends StatefulWidget {
  final String apiKey;
  final String brailleUnicode;
  final String translation;
  final String brailleAudioPath;

  DisplayTranslation({
    required this.brailleUnicode,
    required this.translation,
    required this.apiKey,
    this.brailleAudioPath = '',
  });

  @override
  _DisplayTranslationState createState() => _DisplayTranslationState();
}

class _DisplayTranslationState extends State<DisplayTranslation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlaying = false;
  String? _audioFilePath;

  Future<void> _saveHistoryItem(String audioFilePath) async {
    await HistoryStorage.addHistoryItem(HistoryItem(
      type: HistoryItemType.braille,
      brailleUnicode: widget.brailleUnicode,
      translation: widget.translation,
      brailleAudioPath: audioFilePath,
      timestamp: DateTime.now(),
    ));
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget.translation));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).Textcopiedtoclipboard)),
    );
  }

  void _shareText() {
    Share.share(widget.translation);
  }

  Future<void> _generateAndPlayAudio(String text, String apiKey) async {
    final String apiUrl = 'https://api.openai.com/v1/audio/speech';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'tts-1',
        'input': text,
        'voice': Provider.of<VoiceSettings>(context, listen: false).isMaleVoice ? 'onyx' : 'nova',
      }),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final speechFile = File('${tempDir.path}/speech_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await speechFile.writeAsBytes(bytes);
      final audioFilePath = speechFile.path;

      await _audioPlayer.play(DeviceFileSource(audioFilePath));
      await _saveHistoryItem(audioFilePath);
    } else {
      throw Exception('Failed to generate audio');
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
  }

  //Future<void> _copyText() async {
    // Implement copy functionality
  //}

  //Future<void> _shareText() async {
    // Implement share functionality
  //}



  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
    _audioFilePath = widget.brailleAudioPath.isNotEmpty ? widget.brailleAudioPath : null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound() async {
    if (!_isAudioPlaying) {
      setState(() {
        _isAudioPlaying = true;
      });
      if (_audioFilePath != null && _audioFilePath!.isNotEmpty) {
        await _audioPlayer.play(DeviceFileSource(_audioFilePath!));
      } else {
        await _generateAndPlayAudio(widget.translation, widget.apiKey);
      }
      setState(() {
        _isAudioPlaying = false;
      });
    } else {
      await _stopAudio();
      setState(() {
        _isAudioPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(apiKey: widget.apiKey),
              ),
            );
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'images/brailletransico.png',
              height: 32,
              width: 32,
            ),
            SizedBox(width: 10),
            Text(
              S.of(context).BrailleTranslation,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF-Pro',
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Braille Text',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'SF-Pro',
                letterSpacing: 0.4,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 232, 234, 255),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.brailleUnicode,
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(S.of(context).Translation,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'SF-Pro',
                letterSpacing: 0.4,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 232, 234, 255),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.translation,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF-Pro',
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 234, 255),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _copyText,
                          icon: Icon(
                            Icons.copy,
                            color: Colors.black,
                          ),
                          label: Text(
                            S.of(context).Copy,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF-Pro',
                              letterSpacing: 0.4,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Adjust padding here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _shareText,
                          icon: Icon(
                            Icons.ios_share_outlined,
                            color: Colors.black,
                          ),
                          label: Text(
                            S.of(context).Share,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF-Pro',
                              letterSpacing: 0.4,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Adjust padding here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Audio Playback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'SF-Pro',
                letterSpacing: 0.4,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 234, 255),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _playSound,
                icon: Icon(
                  Icons.volume_up_outlined,
                  color: Colors.black,
                ),
                label: Text(S.of(context).PlayAudio,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF-Pro',
                    letterSpacing: 0.4,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
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
