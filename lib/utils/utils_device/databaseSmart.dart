import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;


class DatabaseSmartPlug {


  static Future<void> addSmart({
    required String nameSmart_plug,
    required String buildingId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('Smart_plug').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "plug_name": nameSmart_plug,
      "plug_id": documentReferencer.id,
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
    DocumentReference documentReferencer = firestore.collection('Smart_plug').doc(
        docId);

    Map<String, dynamic> data = <String, dynamic>{
      "plug_name": nameSmart_plug,
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
    return FirebaseFirestore.instance.collection("Smart_plug")
        .where('building_id', isEqualTo:doc3 )
        .snapshots();

    /*CollectionReference notesItemCollection = firestore.collection('Smart_plug');

    return notesItemCollection.snapshots();*/
  }


  static Future<void> deleteSmart({
    required String docId,
  }) async {
    DocumentReference documentReferencer = firestore.collection('Smart_plug').doc(
        docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note Smart Plug deleted from the database'))
        .catchError((e) => print(e));
  }
}