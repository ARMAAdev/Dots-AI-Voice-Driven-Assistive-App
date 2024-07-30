import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'home_page_content.dart';
import 'History.dart';
import 'BrailleTranslation.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dots/generated/l10n.dart';
import 'package:dots/vision.dart';
import 'package:dots/reader.dart';

class HomePage extends StatefulWidget {
  final String apiKey;
  HomePage({required this.apiKey});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  IconData _fabIcon = Icons.translate;
  final iconList = <IconData>[
    Icons.home,
    Icons.translate,
    Icons.history,
  ];

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_animationController!);
    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == 'SystemNavigator.pop') {
        return await _onWillPop();
      }
      return null;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              exit(0);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        _animationController!.forward().then((_) {
          _animationController!.reverse();
        });
      }
    });
  }

  void _onFabLongPress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 200, // Adjusted width to bring icons closer
            height: 240, // Slightly increased height for better layout
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildFabOption(Icons.visibility),
                SizedBox(height: 20),
                _buildFabOption(Icons.book),
                SizedBox(height: 20),
                if (_fabIcon != Icons.translate)
                  _buildFabOption(Icons.translate),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFabOption(IconData iconData) {
    return CircleAvatar(
      radius: 33,  // Circle radius to enclose the icon
      backgroundColor: const Color(0xFF313BF5),
      child: IconButton(
        icon: Icon(iconData, size: 29, color: Colors.black),
        onPressed: () {
          setState(() {
            _fabIcon = iconData;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onFabTap() {
    if (_fabIcon == Icons.visibility) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VisionPage(apiKey: widget.apiKey),
        ),
      );
    } else if (_fabIcon == Icons.book) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReaderPage(apiKey: widget.apiKey),
        ),
      );
    } else if (_fabIcon == Icons.translate) {
      _onItemTapped(2);
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      _buildNewTranslationPage(),
      _buildNewHistoryPage(),
    ];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 350),
          child: _pages[_selectedIndex],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF313BF5),
          ),
          child: Material(
            elevation: 0,
            color: Color(0xFF313BF5),
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: _onFabTap,
              onLongPress: _onFabLongPress,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: _fabIcon == Icons.translate
                    ? Icon(_fabIcon, size: 32, color: Colors.white)
                    : Image.asset('images/braillego.png', width: 50, height: 50),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildHomePage() {
    return HomePageContent(
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      apiKey: widget.apiKey,
    );
  }

  Widget _buildNewTranslationPage() {
    return BrailleTranslation(apiKey: widget.apiKey);
  }

  Widget _buildNewHistoryPage() {
    return History();
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 12,
      color: Color(0xFF313BF5),
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavigationItem(Icons.home_rounded, 'Home', 0),
            SizedBox(width: 35),
            _buildBottomNavigationItem(Icons.replay_circle_filled_outlined, 'History', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animation!,
            child: Icon(
              icon,
              color: _selectedIndex == index ? Colors.white : Colors.white70,
              size: _selectedIndex == index ? 36 : 30,
            ),
          ),
          DefaultTextStyle(
            style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.white70,
              fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'SF-Pro',
              letterSpacing: 0.5,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
