import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_building/edit_building_screen.dart';
import 'package:log_in/screens/screens_device/list_device_smart_screen.dart';
import 'package:log_in/utils/databaseBuilding.dart';
import 'package:log_in/utils/utils_device/navigaion.dart';


class BuildingList extends StatefulWidget {
  final User user;
  const BuildingList({required this.user});


  
  _BuildingList createState() => _BuildingList();}
  class _BuildingList extends State<BuildingList> {

    late User u;

    @override
    void initState() {
      u = widget.user ;
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: DatabaseBuilding.readBuildings(buildingOwnerId:u.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 16.0),

              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var noteInfo = snapshot.data!.docs[index].data();
                String docID = snapshot.data!.docs[index].id;
                String nameBuilding = noteInfo['building_name'];
                String typeBuilding = noteInfo['type'];


               
                return Ink(
                    child: Container(
                      width: 10.0,
                      height: 87.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(4, 4), // Shadow position
                      ),
                    ],
                    color: Color(0xFFF6FCFF),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(

                    leading:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                    flex: 40,
                      child :IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFF0390C3),size: 20,),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditBuildingScreen(
                                        currentNameDevice: nameBuilding,
                                        currentTypeDevice: typeBuilding,
                                        documentId: docID,
                                      ),
                                ),
                              );
                      },
                    ),
                    ),
                    Expanded(
                        flex: 30,
                        child : IconButton(
                            icon: Icon(Icons.delete, color: Colors.red,size: 20,),
                            onPressed: ()  {
                              showAlertDialog(context, docID);
                            }
                        ),
                    ),


                  ]
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),


                    ),

                     onTap: () => Navigator.of(context).push(
                     MaterialPageRoute(
                     builder: (context) => Navigation(
                      BuildingId: docID, user: u,
                    ),
                     ),
                       ),
                    title: Text(
                      nameBuilding,
                      style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,

                    ),
                    subtitle: Text(
                      typeBuilding,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),


                     /*trailing: Wrap(
                      spacing: 0,

                      children: <Widget>[

                        IconButton(
                          alignment: Alignment.centerLeft,
                          //  padding: EdgeInsets.only(right: 1),

                          onPressed: () =>
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditBuildingScreen(
                                        currentNameDevice: nameBuilding,
                                        currentTypeDevice: typeBuilding,
                                        documentId: docID,

                                      ),
                                ),
                              ),
                          icon: Icon(Icons.edit), color: Colors.red,),


                        // icon-1
                        IconButton(
                          alignment: Alignment.centerLeft,

                          onPressed: () {
                            showAlertDialog(context, docID);
                          }, icon: Icon(Icons.delete), color: Colors.red,),
                        // icon-2
                      ],
                    ),*/
                  ),

                    ),
                );

                // trailing: IconButton(
                //color: Colors.red,
                // icon: Icon(Icons.edit),
                //       iconSize: 20,
                //     alignment: Alignment.bottomLeft,
                //   onPressed: () {

                // },
                //),


                // onSelected: (String value) => SelectedItem(value),


              },
            );
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
        height: 45,// <-- Your width
          child:TextButton(
        child: Text("حذف",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.red,),),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xD2EFEFEF))),
            onPressed: () {
          Navigator.of(context).pop();
          DatabaseBuilding c1;
          c1 = DatabaseBuilding.deleteBuilding(docId: doc) as DatabaseBuilding;
        },
        ),

      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        backgroundColor: Colors.white,
        title: Text("تأكيد حذف المبنى ",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.right,),

        content: Text("هل تريد تأكيد حذف المبنى ؟",
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


  }
