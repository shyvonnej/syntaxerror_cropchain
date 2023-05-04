import 'package:cropchain/mainpage.dart';
import 'package:cropchain/setting.dart';
import 'package:flutter/material.dart';
import 'cusorders.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Inventory";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      const MainPage(),
      const OrderPage(),
      const Setting(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.blueGrey,
        unselectedFontSize: 0,
        selectedFontSize: 10,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        elevation: 0,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white), label: "Invetory"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list, color: Colors.white), label: "Orders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.white), label: "Settings"),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (_currentIndex == 0) {
        maintitle = "Inventory";
      }
      if (_currentIndex == 1) {
        maintitle = "Orders";
      }
      if (_currentIndex == 2) {
        maintitle = "Settings";
      }
    });
  }
}
