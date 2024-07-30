import 'package:dots/settings.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'display_reader.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dots/generated/l10n.dart';

class ReaderPage extends StatefulWidget {
  final String apiKey;
  ReaderPage({Key? key, required this.apiKey}) : super(key: key);
  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  File? _image;
  bool _isLoading = false;
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = Provider.of<ReaderLanguageSettings>(context, listen: false).selectedReaderLanguageCode;
  }

  Future getImage(bool isCamera) async {
    XFile? image = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      _isLoading = true;
    });

    if (_image == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Compress the image before sending it to the API
    List<int> compressedImageBytes = await FlutterImageCompress.compressWithList(
      await _image!.readAsBytes(),
      minWidth: 800,
      minHeight: 800,
      quality: 40,
    );

    // Encode the compressed image bytes to base64
    String base64Image = base64Encode(compressedImageBytes);

    // Create the request payload
    Map<String, dynamic> requestPayload = {
      "model": "gpt-4o",
      "messages": [
        {
          "role": "user",
          "content": [
            {"type": "text", "text": "Please extract and provide only the text from the image. Do not describe or analyze the image itself. Provide the response in ${_selectedLanguageCode.toLowerCase()}, if the image contains a language different from the language you're supposed to give the response in, then translate directly, just act as a translator, your response should just contain the extracted text or the translation of the extracted text, that's it! (if there are any numbers and units in arabic, always convert them to english, and convert any units abbreviation to its original form, eg: cm to centimetres, kg to kilograms etc) (if the language is arabic, please add diactrics to it)"},
            {
              "type": "image_url",
              "image_url": {
                "url": "data:image/jpeg;base64,$base64Image",
              },
            },
          ],
        }
      ],
      "max_tokens": 1000,
    };

    try {
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.apiKey}', // Use the apiKey from the widget
        },
        body: json.encode(requestPayload),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        String extractedText = responseData['choices'][0]['message']['content'];

        if (_image != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayReader(
                extractedText: extractedText,
                apiKey: widget.apiKey,
                audioFilePath: '',
              ),
            ),
          );
        }
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
        // Consider showing an error message on the UI
      }
    } catch (e) {
      print(e);
      // Consider showing an error message on the UI
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readerLanguages = [
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
          body: Container(
    padding: EdgeInsets.all(20),
    child: SingleChildScrollView(
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
    ),child: Theme(
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
                value: _selectedLanguageCode,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguageCode = newValue!;
                  });
                },
                items: readerLanguages.map<DropdownMenuItem<String>>((Map<String, String> language) {
    return DropdownMenuItem<String>(
    value: language['code'],
    child: Row(
    children: [
    Padding(
    padding: EdgeInsets.only(top: 2),
    child: Image.asset(
    language['flag']!,
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
              minimumSize: Size(double.infinity, 0),
              backgroundColor: Colors.white,
            ),
          ),
        ),],
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
            : Text(S.of(context).uploadBT,
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
          ),
    );
  }
}
