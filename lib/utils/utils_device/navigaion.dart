import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_building/add_building_screen.dart';
import 'package:log_in/screens/screens_building/list_building_screen.dart';
import 'package:log_in/screens/screens_device/list_device_smart_screen.dart';
import 'package:log_in/screens/screens_device/report.dart';


class Navigation extends StatefulWidget {
  final String BuildingId;
  final User user;
  Navigation({
    required this. BuildingId,
    required this.user,
  });
  @override
  _NavigationState createState() => _NavigationState();

}

class _NavigationState extends State<Navigation> {


  late User u;

  @override
  void initState() {
    u = widget.user ;
    super.initState();
  }


  int _selectedIndex = 1;

  late final List<Widget> _widgetOptions = [ListBuildingScreen(user: u),ListDeviceSmartScreen(user: u, BuildingId: widget.BuildingId,),Report(user: u, BuildingId: widget.BuildingId,)];

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
        selectedItemColor: Color(0xFFFFC800),
       // backgroundColor: Color(0xFF0390C3),
        //selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: 'الصفحة الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.apps,), label: 'الاجهزة والقابس الذكي'),
          BottomNavigationBarItem(icon: Icon(Icons.text_snippet,), label: 'تقرير استهلاك المبنى'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );

  }
}