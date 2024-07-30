import 'package:flutter/material.dart';
import 'items.dart';
import 'home_page.dart';
import 'package:dots/generated/l10n.dart';


class WelcomePage extends StatefulWidget {
  final String apiKey;
  WelcomePage({required this.apiKey});
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<Widget> slides(BuildContext context) {
    return getItems(context).map((item) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Image.asset(
                item['image'],
                fit: BoxFit.fitWidth,
                width: 220.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: <Widget>[
                    Text(item['header'],
                        style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Color(0XFF3F3D56),
                            height: 2.0)),
                    Text(
                      item['description'],
                      style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 0.7,
                          fontFamily: 'SF-Pro',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          height: 1.3),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  List<Widget> indicator() => List<Widget>.generate(
    slides(context).length,
        (index) => Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: currentPage.round() == index
            ? Color(0xFF313BF5)
            : Color(0xFF313BF5).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );

  double currentPage = 0.0;
  final _pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides(context).length,
              itemBuilder: (BuildContext context, int index) {
                return slides(context)[index];
              },
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                margin: EdgeInsets.only(top: 70.0),
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicator(),
                ),
              ),
            ),
            currentPage.round() == slides(context).length - 1
                ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(apiKey: widget.apiKey)),
                    );
                  },
                  child: Text(S.of(context).GetStarted),
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}