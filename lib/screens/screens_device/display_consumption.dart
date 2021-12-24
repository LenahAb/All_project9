import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:group3/utils/background_image_widget.dart';

class DisplayConsumption extends StatefulWidget {
  //
  final String deviceId;

  DisplayConsumption({required this.deviceId});

  @override
  _DisplayConsumptionState createState() => _DisplayConsumptionState();
}

class _DisplayConsumptionState extends State<DisplayConsumption> {

  List? currentlyConsumpList;
  List? dailyConsumpList;
  List? monthlyConsumpList;

  static String collectionName = 'Device';
  static String collectionTypeName = 'DeviceType';


  static var range = 0;


  static String currentlyConsump = 'CurrentlyConsumption';
  static String dailyConsump = 'DailyConsumption';
  static String monthlyConsump = 'MonthlyConsumption';



  static var currentlyRef;
  static var monthlyRef;

  String docName = '';
  List<String> itsName = [];

  String deviceName = '';

  Future<Map<String, dynamic>?> getIdType() async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.deviceId)
        .get()
        .then((value) {
      if (value.exists) {
        if (mounted) {
          setState(() {
            deviceName = value.data()!['device_name'];
            docName = value.data()!['device_type'].toString();
            itsName = docName.split('/');
            if (itsName[1].isNotEmpty) {
              itsName[1] = itsName[1].substring(0, itsName[1].length - 1);
            }
          });
        }
      }

      print(value.data()!['device_type'].toString());
      print('******* $itsName *****');
      print('******* ${itsName[1]} *****mm');
    });

    await FirebaseFirestore.instance
        .collection('Type')
        .doc(itsName[1])
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          if (value.data()!['range'] != null) {
            range = value.data()!['range'];
          }
        });
      } else {
        print('empty1');
      }

      print('RANGE IS ******** $range');
    });
  }

  bool isOverCons = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getIdType();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F8FA),
          centerTitle: true,
          elevation: 0,
          title: Text('استهلاك ' + deviceName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0390C3),
                letterSpacing: 2,
              )),
          leading: BackButton(color: Color(0xFF535353)),
        ),
        body: Stack(
          children: [
            Positioned(
                top: 0,
                child: Container(
                  height: size.height / 3,
                  width: size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0390C3).withOpacity(0.7),
                          Color(0xFF0390C3).withOpacity(0.4)
                        ],
                      )),
                )),
            Positioned(
              top: size.height / 3,
              height: size.height *(2/3)-130,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(collectionName)
                          .doc(widget.deviceId)
                          .collection(dailyConsump)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final data = snapshot.requireData;
                        if (data.docs.isNotEmpty) {

                          return Container(
                            padding: const EdgeInsets.all(20),
                            width: size.width,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('الاستهلاك اليومي بالواط ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textDirection: TextDirection.rtl),
                                const Divider(
                                  thickness: 1.5,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFF0390C3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.docs.last
                                            .data()['amount']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      Text(
                                        data.docs.last.id.toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                Text(' عدد ساعات الاستهلاك اليومي ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textDirection: TextDirection.rtl),
                                const Divider(
                                  thickness: 1.5,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                data.docs.last
                                    .data()['hours']!=null?Container(
                                  width: double.infinity,
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFF0390C3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.docs.last
                                            .data()['hours']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),

                                    ],
                                  ),
                                ):Container(),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }


                      },
                    ),


                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(collectionName)
                          .doc(widget.deviceId)
                          .collection(monthlyConsump)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final data = snapshot.requireData;

                        if (data.docs.isNotEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            width: size.width,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('الاستهلاك الشهري بالواط',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textDirection: TextDirection.rtl),
                                const Divider(
                                  thickness: 1.5,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFF0390C3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.docs.last
                                            .data()['amount']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      Text(
                                        data.docs.last.id.toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                Text(' عدد ساعات الاستهلاك الشهري',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textDirection: TextDirection.rtl),
                                const Divider(
                                  thickness: 1.5,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                data.docs.last
                                    .data()['hours']!=null?Container(
                                  width: double.infinity,
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFF0390C3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.docs.last
                                            .data()['hours']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),

                                    ],
                                  ),
                                ):Container(),

                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),


                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection(collectionName)
                      .doc(widget.deviceId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    DocumentSnapshot dsnap = snapshot.data;
                    currentlyRef = dsnap.data()!['active_consumption'];

                    if (currentlyRef >= range) {
                      isOverCons = true;
                    } else {
                      isOverCons = false;
                    }
                    return Stack(
                      children: [
                        Positioned(
                            top: 0,
                            child: Container(height:size.height/3,width:size.width,
                              child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                                const Text(
                                  'الاستهلاك الحالي بالواط',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  currentlyRef.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                            )),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: size.width,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isOverCons
                                  ? Colors.red[400]
                                  : Colors.lightGreen[400],
                              // border: Border.all(width: 2)
                            ),
                            child: Center(
                              child: Text(
                                  isOverCons
                                      ?
                                  ' استهلاك $deviceName '+ 'يزيد عن حد معايير الشركة السعودية للكهرباء    '
                                      : ' استهلاك $deviceName '+ 'يتوافق مع معايير الشركة السعودية للكهرباء    ',
                                  style: TextStyle(
                                      color: isOverCons
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18),
                                  textDirection: TextDirection.rtl),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
