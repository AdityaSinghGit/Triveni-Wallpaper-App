import 'package:flutter/material.dart';
import 'package:wallpaper_app/FirstScreen.dart';
import 'package:wallpaper_app/SecondScreen.dart';

class BottomAppbar extends StatefulWidget {
  @override
  _BottomAppbarState createState() => _BottomAppbarState();
}

class _BottomAppbarState extends State<BottomAppbar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    FirstScreen(),
    SecondScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          // elevation: 10,
          backgroundColor: Colors.white,
          selectedIconTheme: IconThemeData(
              color: Color(0xffcc0000), size: 30.0), //bu scarlet red
          selectedItemColor: Color(0xffcc0000),
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          unselectedIconTheme:
              IconThemeData(color: Colors.grey[600], size: 20.0),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_paint),
              label: 'Wallpapers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
