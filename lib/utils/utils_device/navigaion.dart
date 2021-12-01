import 'package:flutter/material.dart';


class Navigation extends StatefulWidget {

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,

      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF7F7F7F),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'الصفحة الرئيسية'),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'الملف الشخصي'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),

    );

  }
}