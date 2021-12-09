import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/utils/utils_device/generated_plugin_registrant.dart';

class Linked extends StatefulWidget {
  final String BuildingId;

  Linked({
    required this. BuildingId,
  });


  @override
  _LinkedState createState() => _LinkedState();
}

class _LinkedState extends State<Linked> {
  var carMake;
  var carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  debugPrint('carMake: $carMake');
    // debugPrint('carMakeModel: $carMakeModel');
    return BackgroundImageWidget(
        image: const AssetImage("assets/Colorized Register&Login v2 – 19.png"),
        child:GestureDetector(
            onTap: () {
            },

            child: Scaffold(
                backgroundColor: Colors.transparent,


                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  title: const Text('ربط جهاز بقابس ذكي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),

                  leading: BackButton(
                      color: Color(0xFF535353)
                  ),
                  backgroundColor: const Color(0xFFF5F8FA),
                ),
                body:
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [

                            Padding(padding: EdgeInsets.only(left: 140 , top: 50.0),
                             // child: Text('ربط جهاز بقابس ذكي ', style: TextStyle(fontSize: 24,
                               // fontWeight: FontWeight.bold,
                               // color: Color(0xFF0390C3),
                               // letterSpacing: 2,),),
                           ),
                          ]),




                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [

                            Padding(padding: EdgeInsets.only(left: 257.0, top: 20.0),
                              child: Text(' اختر جهاز ', style: TextStyle(fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 2,),),
                            ),
                          ]),



                      SizedBox(height: 20.0),
                     Padding(padding: const EdgeInsets.only(left: 30.0,right: 30.0),
                         child: Container(padding:  EdgeInsets.symmetric(horizontal: 10, vertical:13),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width:1),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                                 child: Center(
                                 child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('Device').snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                // Safety check to ensure that snapshot contains data
                                // without this safety check, StreamBuilder dirty state warnings will be thrown
                                if (!snapshot.hasData) return Container();
                                // Set this value for default,
                                // setDefault will change if an item was selected
                                // First item from the List will be displayed
                                if (setDefaultMake) {
                                  carMake = snapshot.data?.docs[0].get('device_name');
                                  debugPrint('setDefault make: $carMake');
                                }
                                return DropdownButton(
                                  dropdownColor: Colors.white,
                                  style: TextStyle(color: Colors.black),
                                  iconEnabledColor:Color(0xFF0390C3),
                                  isExpanded: true,
                                  isDense: true,
                                  iconSize: 34,
                                  underline: Container(),
                                  value: carMake,
                                  items: snapshot.data?.docs.map((value) {
                                    return DropdownMenuItem(
                                        value: value.get('device_name'),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${value.get('device_name')}',style: TextStyle(fontSize: 16)),
                                        ));
                                  }).toList(),
                                  onChanged: (value) {
                                    debugPrint('selected onchange: $value');
                                    setState(
                                          () {
                                        debugPrint('make selected: $value');
                                        // Selected value will be stored
                                        carMake = value;
                                        // Default dropdown value won't be displayed anymore
                                        setDefaultMake = false;
                                        // Set makeModel to true to display first car from list
                                        setDefaultMakeModel = true;
                                      },
                                    );
                                  },

                                );
                              },
                            ),
                            ),
                               ),

                     ),

                            Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Padding(padding: EdgeInsets.only(left: 230.0, top: 40.0,right: 30),
                                    child: Text(' اختر قابس ذكي ', style: TextStyle(fontSize: 20,
                                      color: Colors.black,
                                      letterSpacing: 2,),),
                                  ),
                                ]),



                      SizedBox(height: 20.0),
                    Padding(padding: const EdgeInsets.only(left: 30.0,right: 30.0),
                        child: Container(padding:  EdgeInsets.symmetric(horizontal: 10, vertical:13),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width:1),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                         child: Center(
                           child:StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('SmartPlug').snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                // Safety check to ensure that snapshot contains data
                                // without this safety check, StreamBuilder dirty state warnings will be thrown
                                if (!snapshot.hasData) return Container();
                                // Set this value for default,
                                // setDefault will change if an item was selected
                                // First item from the List will be displayed
                                if (setDefaultMake) {
                                  carMakeModel = snapshot.data?.docs[0].get('smart_plug_name');
                                  debugPrint('setDefault make: $carMakeModel');
                                }
                                return DropdownButton(
                                  dropdownColor: Colors.white,
                                  style: TextStyle(color: Colors.black),
                                  iconEnabledColor:Color(0xFF0390C3),
                                  isExpanded: true,
                                  isDense: true,
                                  iconSize: 34,
                                  underline: Container(),
                                  value: carMakeModel,
                                  items: snapshot.data?.docs.map((value) {
                                    return DropdownMenuItem(
                                        value: value.get('smart_plug_name'),
                                        child: Container(
                                          alignment: Alignment.centerRight,



                                          child: Text('${value.get('smart_plug_name')}',style: TextStyle(fontSize: 16),),

                                        ));
                                  }).toList(),
                                  onChanged: (value) {
                                    debugPrint('selected onchange: $value');
                                    setState(
                                          () {
                                        debugPrint('make selected: $value');
                                        // Selected value will be stored
                                        carMakeModel = value;
                                        // Default dropdown value won't be displayed anymore
                                        setDefaultMake = false;
                                        // Set makeModel to true to display first car from list
                                        setDefaultMakeModel = true;
                                      },
                                    );
                                  },

                                );
                              },
                            ),
                         ),
                         ),
                    ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [

                                  Padding(padding: EdgeInsets.only(top: 30.0,right: 20,left: 20.0),
                                    child: Text(' عند ربط الجهاز تحتاج لضغط القابس الذكي لعشر ثوان حتى يضيئ اللون الأصفر ثم اعد الضغط الى ان يصبح اللون ازرق بعدها اضغط زر ربط الجهاز واضغط الغاء الربط عند فصلك للجهاز من القابس الذكي  ', style: TextStyle(fontSize: 15,
                                      //  fontWeight: FontWeight.bold,

                                      color: Colors.black,
                                      letterSpacing: 2,), textAlign: TextAlign.right,),
                                  ),
                                ]),



                            Center(
                              child:Padding(padding: EdgeInsets.only(top: 50,left: 60.0, right: 60.0,),

                                child:Container(width: MediaQuery.of(context).size.width / 2,



                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Color(0xFF0390C3),),

                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      connect c=connect(carMake,carMakeModel,context);

                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                                      child: Text(
                                        'ربط الجهاز ',
                                        style: TextStyle(
                                          fontSize: 18,
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
                            Padding(padding: EdgeInsets.only(top:15,left: 60.0, right: 60.0,),

                              child:Container(//width: MediaQuery.of(context).size.width / 2,



                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red,),


                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),

                                      ),
                                    ),
                                  ),
                                  onPressed: () async {

                                    disconnect c=disconnect(carMake,carMakeModel,context);


                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                                    child: Text(
                                      'الغاء ربط الجهاز ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),


                    ])
                ),

            )));
  }}



