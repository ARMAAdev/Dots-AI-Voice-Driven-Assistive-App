import 'dart:convert';
import 'package:dots/settings.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:dots/History.dart';
import 'package:dots/generated/l10n.dart';

class DisplayVision extends StatefulWidget {
  final String imagePath;
  final String apiKey;
  final String imageAnalysis;
  final String audioFilePath;

  DisplayVision({
    required this.imagePath,
    required this.apiKey,
    required this.imageAnalysis,
    required this.audioFilePath,
  });

  @override
  _DisplayVisionState createState() => _DisplayVisionState();
}

class _DisplayVisionState extends State<DisplayVision> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlaying = false;
  String? _audioFilePath;

  Future<void> _saveHistoryItem() async {
    await HistoryStorage.addHistoryItem(HistoryItem(
      type: HistoryItemType.vision,
      imagePath: widget.imagePath,
      text: widget.imageAnalysis,
      visionAudioPath: _audioFilePath ?? '',
      timestamp: DateTime.now(),
    ));
  }

  List<String> _voiceIds = [];

  @override
  void initState() {
    super.initState();
    _audioFilePath = widget.audioFilePath;
    _getAvailableVoices();
  }

  Future<void> _getAvailableVoices() async {
    final response = await http.get(
      Uri.parse('https://api.elevenlabs.io/v1/voices'),
      headers: {
        'xi-api-key': '55078fcd6a2f552bfc9e2116ad2e66b3',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> voices = jsonResponse['voices'];
      _voiceIds = voices.map((voice) => voice['voice_id'] as String).toList();

      // Print the list of available voices
      print('Available Voices:');
      voices.forEach((voice) {
        final voiceId = voice['voice_id'];
        final voiceName = voice['name'];
        final voiceCategory = voice['category'];
        print('Voice ID: $voiceId, Name: $voiceName, Category: $voiceCategory');
      });
    } else {
      print('Failed to retrieve available voices. Status code: ${response
          .statusCode}');
    }
  }

  Future<void> _generateAndPlayAudio(String text) async {
    final String apiKey = widget.apiKey;
    final String apiUrl = 'https://api.elevenlabs.io/v1/text-to-speech/{voice_id}';
    final String voiceId = Provider
        .of<VoiceSettings>(context, listen: false)
        .isMaleVoice
        ? 'pNInz6obpgDQGcFmaJgB'
        : 'XB0fDUnXU5powFXDhCwa';
    final String modelId = 'eleven_multilingual_v2';

    if (_audioFilePath != null && _audioFilePath!.isNotEmpty) {
      await _audioPlayer.play(DeviceFileSource(_audioFilePath!));
    } else {
      final payload = {
        'text': text,
        'model_id': modelId,
        'voice_settings': {
          'stability': 0.8,
          'similarity_boost': 0.8,
          "style": 1,
        },
      };

      final response = await http.post(
        Uri.parse(apiUrl.replaceAll('{voice_id}', voiceId)),
        headers: {
          'xi-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final timestamp = DateTime
            .now()
            .millisecondsSinceEpoch;
        final speechFile = File('${tempDir.path}/speech_$timestamp.mp3');
        await speechFile.writeAsBytes(bytes);
        _audioFilePath = speechFile.path;

        await _audioPlayer.play(DeviceFileSource(speechFile.path));
        await _saveHistoryItem();
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
      print(widget.imageAnalysis);
      await _generateAndPlayAudio(widget.imageAnalysis);
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

  void _copyImageAnalysisText() {
    Clipboard.setData(ClipboardData(text: widget.imageAnalysis));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S
          .of(context)
          .Textcopiedtoclipboard)),
    );
  }

  void _shareImage() {
    Share.shareFiles([widget.imagePath]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/visionico2.png',
              height: 32,
              width: 32,
            ),
            SizedBox(width: 10),
            Text(
              S
                  .of(context)
                  .Vision,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                child: Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.contain,
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
                            onPressed: _copyImageAnalysisText,
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
                            onPressed: _shareImage,
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
                  label: Text(
                    S.of(context).PlayAudio,
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
      ),
    );
  }
}