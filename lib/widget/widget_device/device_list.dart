import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group3/screens/screens_device/display_consumption.dart';
import 'package:group3/screens/screens_device/edit_device_screen.dart';
import 'package:group3/screens/screens_device/linked.dart';
import 'package:group3/utils/utils_device/databaseDevice.dart';

class DeviceList extends StatefulWidget {
  final String BuildingId;

  DeviceList({
    required this. BuildingId,
  });

  @override
  _DeviceList createState() => _DeviceList();}

class _DeviceList extends State<DeviceList> {
  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseDevice.readDevices(buildingId: widget.BuildingId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          if(snapshot.data!.docs.isNotEmpty){
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
               var noteInfo = snapshot.data!.docs[index].data()!;
              String docID = snapshot.data!.docs[index].id;
              String nameDevice = noteInfo['device_name'];
              final typeDevice = noteInfo['device_type'];



              return Ink(
                decoration: BoxDecoration(
                   boxShadow: [
                     BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(1, 2), // Shadow position
                     ),
                   ],

                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),

                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert, color:Colors.black,),
                    color: Colors.white,
                    offset: Offset(0, 50),

                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,child: Container(
                          alignment: Alignment.centerRight,
                          child: Text('تعديل معلومات الجهاز '),),
                        ),
                        PopupMenuItem(
                          value: 1,
                        child: Container(
                      alignment: Alignment.centerRight,
                          child: Text('ربط الجهاز بالقابس الذكي'),),
                        ),
                        PopupMenuItem(
                          value: 2,
                      child: Container(
                      alignment: Alignment.centerRight,
                          child: Text('حذف الجهاز  '),),
                        )
                      ];
                    },
                    onSelected: (int value) async {
                      switch (value) {
                        case 0:
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditDeviceScreen(
                                currentNameDevice: nameDevice,
                                currentTypeDevice: typeDevice,
                                documentId: docID,
                              ),
                            ),
                          );
                          break;

                        case 1:
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Linked(BuildingId: widget.BuildingId),
                            ),
                          );
                          break;

                        case 2:
                          _isDeleting = true;
                          showAlertDialog(context,docID);
                          break;
                      }
                    },
                  ),
                  onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                  builder: (context) => DisplayConsumption(
                  deviceId: docID,

                  ),
                  ),
                     ),

                  title: Text(
                    nameDevice,
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                /*  subtitle: Text(
                    "الجاهز مربوط",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),*/
                ),
              );
            },
          );
          }else {
            return Center(child:Text('لا توجد أجهزة',  style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),));
          }
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFF0390C3),
            ),
          ),
        );

      },

    );

  }

  void showAlertDialog(BuildContext context, String doc) {
    // set up the buttons

    Widget cancelButton = SizedBox(
        width: 140,
        height: 45,
        child:TextButton(
            child: Text("الغاء",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.blueAccent,),),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xD2EFEFEF))),
            onPressed: () {
              Navigator.of(context).pop();
            }
        )

    );
    Widget continueButton = SizedBox(
      width: 140,
      height: 45,
      child:TextButton(
        child: Text("حذف",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.red,),),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xD2EFEFEF))),
        onPressed: () {
          Navigator.of(context).pop();
          DatabaseDevice c1;
          c1 = DatabaseDevice.deleteDevice(docId: doc) as DatabaseDevice;
        },
      ),

    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text("تأكيد الجهاز ",
        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),
        textAlign: TextAlign.right,),

      content: Text("هل تريد تأكيد حذف الجهاز ؟",
        style: TextStyle(fontSize: 16, color: Colors.black),
        textAlign: TextAlign.right,),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  /*Future<String> getActive({
    required String docID
  }) async {
   final collection = await FirebaseFirestore.instance.collection('Links');
    collection.doc().snapshots().listen((docSnapshot) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (docSnapshot["active"] == true){

        }
        final String t='ffffff';
        //return t;
        // You can then retrieve the value from the Map like this:
        //var value = data?['your_field'];
      }
    });
  }
*/
}