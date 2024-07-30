// import 'package:dots/settings.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'display_reader.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:dots/generated/l10n.dart';
//
//
// class ReaderPage extends StatefulWidget {
//   final String apiKey;
//   ReaderPage({Key? key, required this.apiKey}) : super(key: key);
//   @override
//   _ReaderPageState createState() => _ReaderPageState();
// }
//
// class _ReaderPageState extends State<ReaderPage> {
//   File? _image;
//   bool _isLoading = false;
//   late String _selectedLanguage;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedLanguage = Provider.of<ReaderLanguageSettings>(context, listen: false).selectedReaderLanguage;
//   }
//
//   Future getImage(bool isCamera) async {
//     XFile? image = await ImagePicker().pickImage(
//       source: isCamera ? ImageSource.camera : ImageSource.gallery,
//       imageQuality: 50,
//     );
//
//     if (image != null) {
//       setState(() {
//         _image = File(image.path);
//       });
//     } else {
//       print('No image selected.');
//     }
//   }
//
//   Future<void> uploadImage() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     if (_image == null) {
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }
//
//     // Compress the image before sending it to the API
//     List<int> compressedImageBytes = await FlutterImageCompress.compressWithList(
//       await _image!.readAsBytes(),
//       minWidth: 800,
//       minHeight: 800,
//       quality: 40,
//     );
//
//     // Encode the compressed image bytes to base64
//     String base64Image = base64Encode(compressedImageBytes);
//
//     // Create the request payload
//     Map<String, dynamic> requestPayload = {
//       "model": "gpt-4-turbo",
//       "messages": [
//         {
//           "role": "user",
//           "content": [
//             {"type": "text", "text": "Please extract and provide only the text from the image. Do not describe or analyze the image itself. Provide the response in ${_selectedLanguage.toLowerCase()}, if the image contains a language different from the language you're supposed to give the response in, then translate directly, just act as a translator, your response should just contain the extracted text or the translation of the extracted text, that's it! (if the language is arabic, please add diactrics to it)"},
//             {
//               "type": "image_url",
//               "image_url": {
//                 "url": "data:image/jpeg;base64,$base64Image",
//               },
//             },
//           ],
//         }
//       ],
//       "max_tokens": 1000,
//     };
//
//     try {
//       var response = await http.post(
//         Uri.parse('https://api.openai.com/v1/chat/completions'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${widget.apiKey}', // Use the apiKey from the widget
//         },
//         body: json.encode(requestPayload),
//       );
//
//       if (response.statusCode == 200) {
//         var responseData = json.decode(utf8.decode(response.bodyBytes));
//         String extractedText = responseData['choices'][0]['message']['content'];
//
//         // // Create a new HistoryItem with the extracted text
//         // HistoryItem historyItem = HistoryItem(
//         //   type: HistoryItemType.reader,
//         //   extractedText: extractedText,
//         //   timestamp: DateTime.now(),
//         //   readerAudioPath: '',
//         // );
//         //
//         // await HistoryStorage.addHistoryItem(historyItem);
//
//         if (_image != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DisplayReader(
//                 extractedText: extractedText,
//                 apiKey: widget.apiKey,
//                 audioFilePath: '',
//               ),
//             ),
//           );
//         }
//       } else {
//         print('Error: ${response.statusCode} ${response.reasonPhrase}');
//         // Consider showing an error message on the UI
//       }
//     } catch (e) {
//       print(e);
//       // Consider showing an error message on the UI
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset(
//               'images/reader.png',
//               height: 32,
//               width: 32,
//             ),
//             SizedBox(width: 10),
//             Text(
//               "Reader",
//               style: TextStyle(
//                 fontSize: 19,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(height: 20),
//             Container(
//               width: 180,
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: DropdownButtonFormField<String>(
//                 value: _selectedLanguage,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedLanguage = newValue!;
//                   });
//                 },
//                 items: <String>[S.of(context).ArabicM, S.of(context).EnglishM, S.of(context).FrenchM, S.of(context).MandarinChineseM, S.of(context).Hindi, S.of(context).SpanishM, S.of(context).BengaliM, S.of(context).PortugueseM, S.of(context).RussianM, S.of(context).UrduM, S.of(context).GermanM]
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.zero,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             SizedBox(
//               height: 300,
//               child: _image == null
//                   ? Icon(Icons.image, size: 200, color: Colors.grey[400])
//                   : Image.file(_image!, fit: BoxFit.contain),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: () => getImage(true),
//                   child: Column(
//                     children: [
//                       Icon(Icons.camera_alt, size: 50),
//                       SizedBox(height: 10),
//                       Text('Camera'),
//                     ],
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => getImage(false),
//                   child: Column(
//                     children: [
//                       Icon(Icons.photo_library, size: 50),
//                       SizedBox(height: 10),
//                       Text('Gallery'),
//                     ],
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             if (_image != null)
//               ElevatedButton(
//                 onPressed: _isLoading ? null : uploadImage,
//                 child: _isLoading
//                     ? SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 )
//                     : Text('Upload and Read'),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }}