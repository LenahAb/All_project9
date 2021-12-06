import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
var db=FirebaseFirestore.instance.collection("Links").doc();
var device;
var smart;

var devid;
var plugid;
class connect{
  String? device_id;
  String? plug_id;

  connect(String device_id,String plug_id,BuildContext context) {
    this.device_id = device_id;
    this.plug_id = plug_id;


    device = FirebaseFirestore.instance.collection("Device");
    device.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        if (doc["device_name"] == device_id ) {
          devid = doc["device_id"];

          debugPrint('najoud : $devid');


        }
        smart = FirebaseFirestore.instance.collection("SmartPlug");
        smart.get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((DocumentSnapshot doc) {
            if(doc["smart_plug_name"] == plug_id){
              plugid = doc["smart_plug_id"];
              debugPrint('najoud : $plugid');
            }

            db.set({
              "link_id":db.id,
              "active":true,
              "device_id":devid,
              "smart_plug_id":plug_id,
              "start_time":DateTime.now(),

            });




          });
        });

      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.lightGreen,
        duration: Duration(seconds:30),
        //padding: EdgeInsets.only(right: 30.0),
        action: SnackBarAction(
            label: 'حسنًا',
            textColor: Colors.white,
            onPressed: () {
            }),
        content: Text(
          // 'Your Password has been Changed. Login again !',
          'تم ربط الجهاز بنجاح ',
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.right,
        ),
      ),
    );


  }
}
class disconnect{
  String? device_id;
  String? plug_id;

  disconnect(String device_id,String plug_id,BuildContext context) {
    this.device_id = device_id;
    this.plug_id = plug_id;
    device = FirebaseFirestore.instance.collection("Device");
    device.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        if (doc["device_name"] == device_id ) {
          devid = doc["device_id"];

          debugPrint('najoud : $devid');


        }
        smart = FirebaseFirestore.instance.collection("SmartPlug");
        smart.get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((DocumentSnapshot doc) {
            if(doc["smart_plug_name"] == plug_id){
              plugid = doc["smart_plug_id"];
              debugPrint('najoud : $plugid');
            }

            db.set({
              "end_time":DateTime.now()
            } ,
                SetOptions(merge : true));


          });




        });
      });

    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds:30),
        //padding: EdgeInsets.only(right: 30.0),
        action: SnackBarAction(
            label: 'حسنًا',
            textColor: Colors.white,
            onPressed: () {
            }),
        content: Text(
          // 'Your Password has been Changed. Login again !',
          'تم إلغاء الربط الجهاز بنجاح ',
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.right,
        ),
      ),
    );

  }
}



