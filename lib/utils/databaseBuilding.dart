import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

var user_Uid;

class DatabaseBuilding {


  static Future<void> addBuilding({
    required String nameDevice,
    required String typeDevice,
    required String userUid
  }) async {

    DocumentReference documentReferencer = firestore.collection('Building').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "building_name": nameDevice,
      "building_type": typeDevice,
      "building_id": documentReferencer.id,
      "userUid":firestore.doc('users/'+userUid),
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note Building added to the database"))
        .catchError((e) => print(e));
  }




  static Future<void> updateBuilding({
    required String nameBuilding,
    required String typeBuilding,
    required String docId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('Building').doc(docId);


    Map<String, dynamic> data = <String, dynamic>{
      "building_name": nameBuilding,
      "building_type": typeBuilding,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note Building updated in the database"))
        .catchError((e) => print(e));
  }




  static Stream<QuerySnapshot> readBuildings ({
  required String userUid
  }){
    DocumentReference doc3 = FirebaseFirestore.instance.doc('users/' + userUid);
    return FirebaseFirestore.instance.collection("Building")
        .where('userUid', isEqualTo:doc3 )
        .snapshots();
  }


  static Future<void> deleteBuilding({
    required String docId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('Building').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note Building deleted from the database'))
        .catchError((e) => print(e));
  }
}