import 'dart:convert';
import 'package:dots/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:dots/generated/l10n.dart';

import 'History.dart';

class DisplayReader extends StatefulWidget {
  final String extractedText;
  final String apiKey;
  final String audioFilePath;

  DisplayReader({
    required this.extractedText,
    required this.apiKey,
    required this.audioFilePath,
  });

  @override
  _DisplayReaderState createState() => _DisplayReaderState();
}

class _DisplayReaderState extends State<DisplayReader> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlaying = false;
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
    _audioFilePath = widget.audioFilePath;
  }

  Future<void> _saveHistoryItem() async {
    await HistoryStorage.addHistoryItem(HistoryItem(
      type: HistoryItemType.reader,
      extractedText: widget.extractedText,
      readerAudioPath: _audioFilePath ?? '',
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _generateAndPlayAudio(String text) async {
    final String apiKey = widget.apiKey;
    final String apiUrl = 'https://api.openai.com/v1/audio/speech';

    _audioPlayer = AudioPlayer();

    if (_audioFilePath != null && _audioFilePath!.isNotEmpty) {
      await _audioPlayer.play(DeviceFileSource(_audioFilePath!));
    } else {
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
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final speechFile = File('${tempDir.path}/speech_$timestamp.mp3');
        await speechFile.writeAsBytes(bytes);

        await _audioPlayer.play(DeviceFileSource(speechFile.path));

        if (_audioFilePath == null || _audioFilePath!.isEmpty) {
          _audioFilePath = speechFile.path;
          await _saveHistoryItem();
        }
      } else {
        throw Exception('Failed to generate audio');
      }
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
  }

  void _playSound() async {
    if (!_isAudioPlaying) {
      setState(() {
        _isAudioPlaying = true;
      });
      await _generateAndPlayAudio(widget.extractedText);
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

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget.extractedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).Textcopiedtoclipboard)),
    );
  }

  void _shareText() {
    Share.share(widget.extractedText);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/pictranslateico.png',
              height: 32,
              width: 32,
            ),
            SizedBox(width: 10),
            Text(
              S.of(context).ReadTranslate,
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
            children: [
              SizedBox(
                height: 400, // Set the desired height here
                width: double.infinity, // Set to double.infinity for full width or specify a fixed width
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Color.fromARGB(255, 232, 234, 255), // Set the background color here
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          widget.extractedText,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF-Pro',
                            letterSpacing: 0.4,
                          ),
                        ),
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
                            label: Text(S.of(context).Copy,
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
                              S
                                  .of(context)
                                  .Share,
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
