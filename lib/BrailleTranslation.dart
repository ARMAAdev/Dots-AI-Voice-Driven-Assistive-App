import 'package:dots/settings.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'display_braille.dart';
import 'dart:convert';
import 'package:dots/generated/l10n.dart';

class BrailleTranslation extends StatefulWidget {
  final String apiKey;
  BrailleTranslation({required this.apiKey});

  @override
  _BrailleTranslationState createState() => _BrailleTranslationState();
}

class _BrailleTranslationState extends State<BrailleTranslation> {
  File? _image;
  bool _isLoading = false;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = Provider.of<BrailleLanguageSettings>(context, listen: false).selectedBrailleLanguageCode;
  }

  Future getImage(bool isCamera) async {
    var image = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImage() async {
    setState(() {
      _isLoading = true;
    });

    if (_image == null) return;

    var uri = Uri.parse('https://brailleapi-32aaf2632daf.herokuapp.com/process-image');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    final responseBody = response.bodyBytes;
    print('Raw response bytes: $responseBody');

    final decodedString = utf8.decode(responseBody);
    print('Decoded response string: $decodedString');

    if (response.statusCode == 200) {
      final responseBody = response.bodyBytes;
      final decodedString = utf8.decode(responseBody);

      var responseData = json.decode(decodedString);
      String brailleUnicode = responseData['result'];
      String translation = responseData['translation'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayTranslation(
            apiKey: widget.apiKey,
            brailleUnicode: brailleUnicode,
            translation: translation,
          ),
        ),
      );
    } else {
      print('Server error: ${response.reasonPhrase}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brailleLanguages = [
      {'name': S.of(context).ArabicM, 'code': 'ar', 'flag': 'images/united-arab-emirates.png'},
      {'name': S.of(context).EgyptianArabic, 'code': 'ar_EG', 'flag': 'images/egypt.png'},
      {'name': S.of(context).EnglishM, 'code': 'en', 'flag': 'images/united-kingdom.png'},
      {'name': S.of(context).FrenchM, 'code': 'fr', 'flag': 'images/france.png'},
      {'name': S.of(context).MandarinChineseM, 'code': 'zh', 'flag': 'images/china.png'},
      {'name': S.of(context).HindiM, 'code': 'hi', 'flag': 'images/india.png'},
      {'name': S.of(context).SpanishM, 'code': 'es', 'flag': 'images/spain.png'},
      {'name': S.of(context).BengaliM, 'code': 'bn', 'flag': 'images/bangladesh.png'},
      {'name': S.of(context).PortugueseM, 'code': 'pt', 'flag': 'images/portugal.png'},
      {'name': S.of(context).RussianM, 'code': 'ru', 'flag': 'images/russia.png'},
      {'name': S.of(context).UrduM, 'code': 'ur', 'flag': 'images/pakistan.png'},
      {'name': S.of(context).GermanM, 'code': 'de', 'flag': 'images/germany.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/brailletransico.png',
              height: 32,
              width: 32,
            ),
            SizedBox(width: 10),
            Text(S.of(context).BrailleTranslation,
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Language Options',
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
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 75, // Set the desired width
                        height: 50, // Set the desired height
                        child: Container(
                          padding: EdgeInsets.all(12),
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
                            child: Text(
                              'Braille',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'SF-Pro',
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, size: 28),
                      SizedBox(width: 10),
                      Expanded(
                        child: Theme(
                          data: ThemeData(
                            textTheme: TextTheme(
                              subtitle1: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'SF-Pro',
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          child: Container(
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
                            child: DropdownButtonFormField<String>(
                              value: _selectedLanguage,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedLanguage = newValue!;
                                });
                              },
                              items: brailleLanguages.map<DropdownMenuItem<String>>((Map<String, dynamic> language) {
                                return DropdownMenuItem<String>(
                                  value: language['code'],
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Image.asset(
                                          language['flag'],
                                          width: 18,
                                          height: 18,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        language['name']!,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.fromLTRB(13, 11, 13, 14),
                              ),
                              icon: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                              iconEnabledColor: Colors.black,
                              dropdownColor: Colors.white,
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
              'Choose an Image',
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
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => getImage(true),
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 50,
                                color: Colors.black,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Camera',
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
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 0),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => getImage(false),
                          child: Column(
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 50,
                                color: Colors.black,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Gallery',
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
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize:
                            Size(double.infinity, 0), // Adjust width
                            backgroundColor: Colors.white,
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
              'Image Preview',
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
              padding: EdgeInsets.fromLTRB(15, 3, 15, 13),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 234, 255),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 170,
                    child: Center(
                      child: _image == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined,
                              size: 130, color: Colors.black),
                          SizedBox(height: 10),
                          Text(
                            'No Image Uploaded',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'SF-Pro',
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  if (_image != null)
                    ElevatedButton(
                      onPressed: _isLoading ? null : uploadImage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            'Upload and Translate',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'SF-Pro',
                              letterSpacing: 0.4,
                            ),
                          ),
                          SizedBox(width: 7),
                          SizedBox(
                            width: 20,
                            height: 33,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20), // Adjusted padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize:
                        Size(double.infinity, 40), // Adjusted minimum size
                        backgroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
