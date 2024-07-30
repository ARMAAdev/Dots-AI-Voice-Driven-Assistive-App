import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'display_braille.dart';
import 'display_reader.dart';
import 'display_vision.dart';
import 'package:dots/generated/l10n.dart';

enum HistoryItemType {
  vision,
  reader,
  braille,
}

class HistoryStorage {
  static const String _fileName = 'history.json';

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  static Future<List<HistoryItem>> readHistory() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      print('History file contents: $contents');

      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((item) => HistoryItem.fromJson(item)).toList();
    } catch (e) {
      print('Error reading history file: $e');
      return [];
    }
  }

  static Future<void> saveHistory(List<HistoryItem> history) async {
    final file = await _localFile;
    final jsonData = history.map((item) => item.toJson()).toList();
    await file.writeAsString(json.encode(jsonData));
  }

  static Future<void> addHistoryItem(HistoryItem item) async {
    final history = await readHistory();
    history.add(item);
    await saveHistory(history);
  }
}

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryItem> historyItems = [];
  bool isSelectionMode = false;
  List<HistoryItem> selectedItems = [];
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false; // State variable to track playback status
  HistoryItem? currentlyPlayingItem; // Currently playing item

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final items = await HistoryStorage.readHistory();
    setState(() {
      historyItems = items;
    });
  }

  void _playPauseAudio(HistoryItem item) async {
    if (isPlaying && currentlyPlayingItem == item) {
      await audioPlayer.pause();
    } else {
      if (currentlyPlayingItem != null) {
        await audioPlayer.stop();
      }

      if (item.type == HistoryItemType.reader) {
        await audioPlayer.play(DeviceFileSource(item.readerAudioPath));
      } else if (item.type == HistoryItemType.braille) {
        await audioPlayer.play(DeviceFileSource(item.brailleAudioPath));
      } else if (item.type == HistoryItemType.vision) {
        await audioPlayer.play(DeviceFileSource(item.visionAudioPath));
      }

      audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          isPlaying = false;
          currentlyPlayingItem = null;
        });
      });
    }
    setState(() {
      isPlaying = !isPlaying;
      currentlyPlayingItem = item;
    });
  }

  void _stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
      currentlyPlayingItem = null;
    });
  }

  @override
  void dispose() {
    _stopAudio(); // Stop audio when the page is disposed
    audioPlayer.dispose(); // Dispose of the AudioPlayer
    super.dispose();
  }

  Widget _buildHistoryItem(HistoryItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onLongPress: () {
          if (!isSelectionMode) {
            _toggleSelectionMode();
          }
          _selectItem(item);
        },
        onTap: () {
          if (isSelectionMode) {
            _selectItem(item);
          } else {
            if (item.type == HistoryItemType.vision) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayVision(
                    imagePath: item.imagePath,
                    apiKey: 'your_api_key',
                    imageAnalysis: item.text,
                    audioFilePath: item.visionAudioPath,
                  ),
                ),
              );
            } else if (item.type == HistoryItemType.braille) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayTranslation(
                    brailleUnicode: item.brailleUnicode,
                    translation: item.translation,
                    apiKey: 'your_api_key',
                    brailleAudioPath: item.brailleAudioPath,
                  ),
                ),
              );
            } else if (item.type == HistoryItemType.reader) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayReader(
                    extractedText: item.extractedText,
                    apiKey: 'your_api_key',
                    audioFilePath: item.readerAudioPath,
                  ),
                ),
              );
            }
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: selectedItems.contains(item)
              ? Colors.grey[300]
              : Color.fromARGB(255, 232, 234, 255), //background color
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.type == HistoryItemType.vision)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 50,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'images/visionico2.png',
                                  height: 32,
                                  width: 32,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  S.of(context).Vision,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'SF-Pro',
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10), // border radius
                        child: Image.file(
                          File(item.imagePath),
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),

                if (item.type == HistoryItemType.braille)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200, // Set the desired width
                        height: 50, // Set the desired height
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'images/brailletransico.png',
                                  height: 32,
                                  width: 32,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  S.of(context).BrailleTranslation,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'SF-Pro',
                                    letterSpacing: 0.4,
                                  ),
                                ),
                            ], ),
                          ),
                        ),
      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Braille Text",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'SF-Pro',
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(height: 8), // Adjust the spacing as needed
                            Text(
                              item.brailleUnicode,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            Text(
                              S.of(context).Translation,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'SF-Pro',
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item.translation,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontFamily: 'SF-Pro',
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (item.type == HistoryItemType.reader)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140, // Set the desired width
                        height: 50, // Set the desired height
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'images/pictranslateico.png',
                                  height: 32,
                                  width: 32,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  S.of(context).Reader,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'SF-Pro',
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).ExtractedText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'SF-Pro',
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item.extractedText,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 15),
                if (item.visionAudioPath.isNotEmpty ||
                    item.brailleAudioPath.isNotEmpty ||
                    item.readerAudioPath.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _playPauseAudio(item),
                          icon: Icon(
                            isPlaying && currentlyPlayingItem == item ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.black,
                          ),
                          label: Text(
                            isPlaying && currentlyPlayingItem == item ? 'Pause' : 'Play',
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _stopAudio,
                          icon: Icon(
                            Icons.stop_rounded,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Stop',
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 15),
                Text(
                  item.timestamp.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'SF-Pro',
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      selectedItems.clear();
    });
  }

  void _selectItem(HistoryItem item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  void _selectAllItems() {
    setState(() {
      if (selectedItems.length == historyItems.length) {
        selectedItems.clear();
      } else {
        selectedItems = List.from(historyItems);
      }
    });
  }

  void _deleteSelectedItems() async {
    setState(() {
      historyItems.removeWhere((item) => selectedItems.contains(item));
      selectedItems.clear();
      isSelectionMode = false;
    });
    await HistoryStorage.saveHistory(historyItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).History,
          style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'SF-Pro',
          letterSpacing: 0.4,
        ),),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: Icon(selectedItems.length == historyItems.length
                  ? Icons.clear_all
                  : Icons.select_all),
              onPressed: _selectAllItems,
            ),
          IconButton(
            icon: Icon(isSelectionMode ? Icons.close : Icons.select_all),
            onPressed: _toggleSelectionMode,
          ),
          if (isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedItems,
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          final item = historyItems[index];
          return _buildHistoryItem(item);
        },
      ),
    );
  }
}

class HistoryItem {
  final HistoryItemType type;
  final String text;
  final String imagePath;
  final String brailleUnicode;
  final String translation;
  final String visionAudioPath;
  final String readerAudioPath;
  final String brailleAudioPath;
  final DateTime timestamp;
  final String extractedText;

  HistoryItem({
    required this.type,
    this.text = '',
    this.imagePath = '',
    this.brailleUnicode = '',
    this.translation = '',
    this.visionAudioPath = '',
    this.readerAudioPath = '',
    this.brailleAudioPath = '',
    required this.timestamp,
    this.extractedText = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'text': text,
      'extractedText': extractedText,
      'imagePath': imagePath,
      'brailleUnicode': brailleUnicode,
      'translation': translation,
      'visionAudioPath': visionAudioPath,
      'readerAudioPath': readerAudioPath,
      'brailleAudioPath': brailleAudioPath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    try {
      return HistoryItem(
        type: HistoryItemType.values.firstWhere(
              (e) => e.toString() == json['type'],
          orElse: () => HistoryItemType.vision,
        ),
        text: json['text'] ?? '',
        extractedText: json['extractedText'] ?? '',
        imagePath: json['imagePath'] ?? '',
        brailleUnicode: json['brailleUnicode'] ?? '',
        translation: json['translation'] ?? '',
        visionAudioPath: json['visionAudioPath'] ?? '',
        readerAudioPath: json['readerAudioPath'] ?? '',
        brailleAudioPath: json['brailleAudioPath'] ?? '',
        timestamp: DateTime.parse(json['timestamp']),
      );
    } catch (e) {
      print('Error parsing HistoryItem: $e');
      return HistoryItem(
        type: HistoryItemType.vision,
        timestamp: DateTime.now(),
      );
    }
  }
}
