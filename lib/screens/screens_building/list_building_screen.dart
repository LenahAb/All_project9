import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_device/list_device_smart_screen.dart';
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
   late User _IdUser;

  @override
  void initState() {
    _IdUser = widget.user ;
    super.initState();
    //getBuildingData();
  }
/*
   bool loading = true;
   bool empty=false;

   void getBuildingData() async {
     await FirebaseFirestore.instance.collection('Building').doc('BuildingOwner/'+ _IdUser.uid).get().then((value) {
       if (value.exists) {



       }
      else {
     setState(() {
     empty=true;
     loading = false;
     });
     }
     });
   }*/



  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 20.png"),




      child:Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          elevation: 0,
            automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('المباني',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,
          ),),
           /* leading: Builder(
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

          ),*/
          backgroundColor: Color(0xFFF5F8FA),
            actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => (ProfilePage(user: _IdUser,))));},
                child: Icon(Icons.person,color: Color(0xFF535353),size: 35,),

              )
          ),
  ],
        ),

          bottomNavigationBar:SingleChildScrollView(
   child: Padding(padding: const EdgeInsets.only(right: 300.0,bottom: 20.0,),
    child:FloatingActionButton(
          backgroundColor:Color(0xFF0390C3),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddBuildingScreen(user: _IdUser),
              ),
            ); },
          child: Icon(
            Icons.add,
            color: Colors.white,),
        ),
           ),
    ),




        body:/*loading
            ? Center(child: CircularProgressIndicator()): empty? Center(child:Text('رجاءً أضف مبنى',  style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
         ),))
            : Theme(data:ThemeData.light(),
       child: */SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top:16.0,
              left: 40.0,
              right: 40.0,
              bottom: 30.0,
            ),
            child: BuildingList(user :_IdUser),
          ),
        ),

      ),
  //),
    );
  }


}