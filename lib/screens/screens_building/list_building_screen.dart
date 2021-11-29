import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_home/home_screen.dart';
import 'package:log_in/screens/screens_home/profile_page.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/widget/widget_building/building_list.dart';

import 'add_building_screen.dart';




class ListBuildingScreen extends StatefulWidget {
   final User user;
  const ListBuildingScreen({required this.user});
  @override
  _ListBuildingScreen createState() => _ListBuildingScreen();
}

class _ListBuildingScreen extends State<ListBuildingScreen> {
   late User u;

  @override
  void initState() {
    u = widget.user ;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 20.png"),




      child:Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          elevation: 0,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF535353)),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  }
                );
              },

          ),
          backgroundColor: Color(0xFFF5F8FA),
            actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => (ProfilePage(user: u,))));},
                child: Icon(Icons.person,color: Color(0xFF535353),size: 35,),

              )
          ),
  ],
        ),

          bottomNavigationBar:Padding(
    padding: const EdgeInsets.only(right: 300.0,bottom: 30.0),
    child:FloatingActionButton(
          backgroundColor:Color(0xFF0390C3),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddBuildingScreen(user: u),
              ),
            ); },
          child: Icon(
            Icons.add,
            color: Colors.white,),
        ),
           ),

        body:SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top:16.0,
              left: 40.0,
              right: 40.0,
              bottom: 30.0,
            ),
            child: BuildingList(user :u),
          ),
        ),

       /* bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF0390C3),
          selectedItemColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الصفحة الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
          ],
        ),*/


      ),

    );
  }


}