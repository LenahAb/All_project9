import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
var db=FirebaseFirestore.instance.collection("Device_Plug").doc();
var device;
var smart;

var devid;
var plugid;
class connect{
  String? device_id;
  String? plug_id;

  connect(String device_id,String plug_id) {
    this.device_id = device_id;
    this.plug_id = plug_id;
    device = FirebaseFirestore.instance.collection("Device");
    device.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        if (doc["nameDevice"] == device_id ) {
          devid = doc["DeviseId"];

          debugPrint('najoud : $devid');


        }
        smart = FirebaseFirestore.instance.collection("Smart_plug");
        smart.get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((DocumentSnapshot doc) {
            if(doc["plug_name"] == plug_id){
              plugid = doc["plug_id"];
              debugPrint('najoud : $plugid');
            }

            db.set({
              "Device_Plug_id":db.id,
              "active":true,
              "DeviseId":devid,
              "plug_id":plug_id,
              "start_time":DateTime.now(),

            });




          });
        });

      });
    }
    );}
}
class disconnect{
  String? device_id;
  String? plug_id;

  disconnect(String device_id,String plug_id) {
    this.device_id = device_id;
    this.plug_id = plug_id;
    device = FirebaseFirestore.instance.collection("Device");
    device.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        if (doc["nameDevice"] == device_id ) {
          devid = doc["DeviseId"];

          debugPrint('najoud : $devid');


        }
        smart = FirebaseFirestore.instance.collection("Smart_plug");
        smart.get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((DocumentSnapshot doc) {
            if(doc["plug_name"] == plug_id){
              plugid = doc["plug_id"];
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
  }
}


