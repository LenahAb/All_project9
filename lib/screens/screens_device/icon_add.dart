import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/background_image_widget.dart';

import 'add_device_screen.dart';
import 'add_smart_screen.dart';


class IconAdd extends StatefulWidget {
  final String BuildingId;
  final User user;

  IconAdd({
    required this. BuildingId,
    required this.user
  });
  @override
  _IconAdd createState() => _IconAdd();}

class _IconAdd extends State<IconAdd> {

  late User u;

  @override
  void initState() {
    u = widget.user ;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),


    child:Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
    elevation: 0,
    leading: BackButton(
    color: Color(0xFF535353)
    ),
    backgroundColor: Color(0xFFF5F8FA),
    ),


    body: Column(
    children: [
      Center(child:
      Padding(padding: EdgeInsets.only(top: 250,left: 40.0, right: 40.0,),

        child:Container(width: double.maxFinite,

          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFF0390C3),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddDeviceScreen(BuildingId: widget.BuildingId, user: u,
                       )
                ),
                );


            },
            child: Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text(
                'إضافة جهاز',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ),
      ),


      Center(child:
      Padding(padding: EdgeInsets.only(top: 40,left: 40.0, right: 40.0,),

        child:Container(width: double.maxFinite,

          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFF0390C3),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddSmartScreen(BuildingId: widget.BuildingId, user: u,)
              ),
              );


            },
            child: Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text(
                'إضافة قابس ذكي',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ),
      ),




    ]
    ),

),
    );

  }
}


