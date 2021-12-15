import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;


class DatabaseSmartPlug {


  static Future<void> addSmart({
    required String nameSmart_plug,
    required String keySmart_plug,
    required String buildingId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('SmartPlug').doc(keySmart_plug);

    Map<String, dynamic> data = <String, dynamic>{
      "smart_plug_name": nameSmart_plug,
      "smart_plug_id": keySmart_plug,
      "building_id": firestore.doc('Building/'+buildingId),
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note Smart Plug added to the database"))
        .catchError((e) => print(e));
  }


  static Future<void> updateSmart({
    required String nameSmart_plug,
    required String docId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('SmartPlug').doc(
        docId);

    Map<String, dynamic> data = <String, dynamic>{
      "smart_plug_name": nameSmart_plug,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note Smart Plug updated in the database"))
        .catchError((e) => print(e));
  }


  static Stream<QuerySnapshot> readSmart(
      {required String buildingId,}
      ){
    DocumentReference doc3 = FirebaseFirestore.instance.doc('Building/' + buildingId);
    return FirebaseFirestore.instance.collection("SmartPlug")
        .where('building_id', isEqualTo:doc3 )
        .snapshots();

    /*CollectionReference notesItemCollection = firestore.collection('Smart_plug');

    return notesItemCollection.snapshots();*/
  }


  static Future<void> deleteSmart({
    required String docId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('SmartPlug').doc(
        docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note Smart Plug deleted from the database'))
        .catchError((e) => print(e));
  }
}