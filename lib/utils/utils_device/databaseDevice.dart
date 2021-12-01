import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;


class DatabaseDevice {


  static Future<void> addDevice({
    required String nameDevice,
    required String typeDevice,
    required String buildingId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('Device').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "nameDevice": nameDevice,
      "deviseId": documentReferencer.id,
      "typeDevice": firestore.doc('Type/3QEEcZyegpb9wS1OPGca'),
      "building_id": firestore.doc('Building/'+buildingId
     ),
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note Device added to the database"))
        .catchError((e) => print(e));
  }




  static Future<void> updateDevice({
    required String nameDevice,
    required String typeDevice,
    required String docId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('Device').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "nameDevice": nameDevice,
      "typeDevice": typeDevice,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note Device updated in the database"))
        .catchError((e) => print(e));
  }




  static Stream<QuerySnapshot> readDevices (
      {required String buildingId,}
  ){
    /*CollectionReference notesItemCollection = FirebaseFirestore.instance
        .collection('Device')
        .withConverter<TheAmount>(
      fromFirestore: (snapshots, _) => TheAmount.fromJson(snapshots.data()!),
      toFirestore: (movie, _) => movie.toJson(),
    );*/

    DocumentReference doc3 = FirebaseFirestore.instance.doc('Building/' + buildingId);
    return FirebaseFirestore.instance.collection("Device")
        .where('building_id', isEqualTo:doc3 )
        .snapshots();

    /* CollectionReference notesItemCollection = firestore.collection('Device');

    return notesItemCollection.snapshots();*/


  }




  static Future<void> deleteDevice({
    required String docId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('Device').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note Device deleted from the database'))
        .catchError((e) => print(e));
  }
}