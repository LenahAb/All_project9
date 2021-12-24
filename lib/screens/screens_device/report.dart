import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:group3/utils/background_image_widget.dart';
import 'package:group3/utils/utils_device/device_data.dart';
import 'package:group3/utils/utils_device/month_model.dart';
import 'package:group3/utils/utils_device/navigaion.dart';

class Report extends StatefulWidget {
  final String BuildingId;
  final User user;

  Report({required this.BuildingId, required this.user});
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late User u;

  bool loading = true;
  bool empty = false;
  String buildingName = '';

  // put data for chart
  List<ReportSeries> data = [];
  List<MonthModel> monthModel = [];

  // put data to the chosen month for chart

  // give the chart for ths chosen month
  Future<void> addGraph(String monthValue) async {
    setState(() {
      data = [];
    });

    for (DeviceData element in deviceData) {
      await FirebaseFirestore.instance
          .collection('Device')
          .doc(element.id)
          .collection('MonthlyConsumption')
          .doc(monthValue)
          .get()
          .then((value) {
        if (value.exists) {
          data.add(ReportSeries(
            name: element.name,
            amount: value.data()!['amount'],
            barColor: charts.ColorUtil.fromDartColor(Color(0xFF0390C3)),
          ));
        }
      });
    }
  }

  Object? dropValue;
  var fullAmount = 0.0;
  var fullCost = 0.0;

  // calculate all consumptions in specific month

  // calculate all cost in specific month

  void getMonthsData() async {
    await FirebaseFirestore.instance
        .collection('Building')
        .doc(widget.BuildingId)
        .get()
        .then((value) {
      if (value.exists) {
        buildingName = value['building_name'];

        value.reference.collection('MonthlyConsumption').get().then((v) {
          if (v.docs.isNotEmpty) {
            v.docs.forEach((item) {

              if(item.data()['amount']!=null && item.data()['cost']!=null){
                monthModel.add(MonthModel(
                    consumption: item.data()['amount'],
                    cost: item.data()['cost'],
                    month: item.id));
              }

            });

            monthModel.sort((a, b) => a.month.compareTo(b.month));
            dropValue = monthModel.last.month;
            fullAmount = monthModel.last.consumption;
            fullCost = monthModel.last.cost;
            loading = false;
            addGraph(dropValue.toString()).then((_) {
              setState(() {});
            });
          } else {
            setState(() {
              empty = true;
              loading = false;
            });
          }
        });
      } else {
        setState(() {
          empty = true;
          loading = false;
        });
      }
    });
  }

  String docName = '';

  // put devices name & id in list
  List<DeviceData> deviceData = [];

  // get devices names and IDs
  void getDevicesNames() async {
    await FirebaseFirestore.instance.collection('Device').get().then((value) {
      value.docs.forEach((element) {
        List<String> aa = element.data()['building_id'].toString().split('/');
        String buildingId = aa[1].substring(0, aa[1].length - 1);
        if (buildingId == widget.BuildingId) {
          deviceData
              .add(DeviceData(id: element.id, name: element['device_name']));
        }
      });

      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    u = widget.user;
    super.initState();
    getDevicesNames();
    getMonthsData();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF535353)),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            Navigation(user: u, BuildingId: widget.BuildingId),
                      ),
                    );
                  });
            },
          ),
          backgroundColor: Color(0xFFF5F8FA),
          centerTitle: true,
          title: Text(
            ' تقرير $buildingName',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0390C3),
              letterSpacing: 2,
            ),
          ),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : empty
            ? Center(
            child: Text(
              'لا يوجد استهلاك',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ))
            : Theme(
          data: ThemeData.light(),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الاستهلاك الشهري لأجهزة $buildingName ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          // textDirection: TextDirection.rtl
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 1),
                            width:
                            MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black38, width: 1),
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: DropdownButton(
                              dropdownColor: Colors.white,
                              style: TextStyle(color: Colors.black),
                              iconEnabledColor: Color(0xFF0390C3),
                              isExpanded: true,
                              isDense: true,
                              iconSize: 34,
                              underline: Container(),
                              value: dropValue,
                              items: monthModel.map((items) {
                                return DropdownMenuItem(
                                  value: items.month,
                                  child: Text(items.month),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                dropValue = newValue;

                                MonthModel model =
                                monthModel.firstWhere((element) =>
                                element.month == newValue);
                                fullAmount = model.consumption;
                                fullCost = model.cost;
                                addGraph(dropValue.toString())
                                    .then((_) {
                                  setState(() {});
                                });
                                //  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Report()));
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 250,
                          child: ReportChart(
                            data: data,
                          ),
                        ),
                        Container(
                          height: 3,
                          color: Colors.grey[300],
                        ),

                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('الاستهلاك الشهري بالواط ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textDirection: TextDirection.rtl),

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
                                fullAmount.toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                              Text(
                                '$dropValue',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('تكلفة الاستهلاك الشهري بالريال السعودي',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textDirection: TextDirection.rtl),
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
                                fullCost.toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                              Text(
                                '$dropValue',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// define class to select data for chart
class ReportSeries {
  final String name;
  final dynamic amount;
  final charts.Color barColor;

  ReportSeries(
      {required this.name, required this.amount, required this.barColor});
}

// define class to put data in the chart
class ReportChart extends StatelessWidget {
  final List<ReportSeries> data;

  ReportChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ReportSeries, String>> series = [
      charts.Series(
        id: "MonthlyConsumption",
        data: data, // select what data to use
        domainFn: (ReportSeries series, _) =>
        series.name, // display names in x-line
        measureFn: (ReportSeries series, _) =>
        series.amount, // display amounts in y-line
        colorFn: (ReportSeries series, _) => series.barColor, // choose color
      )
    ];

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 400,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: charts.BarChart(
                  series,
                  animate: true,
                  animationDuration: Duration(milliseconds: 100),
                ),
              ),
              Column(mainAxisAlignment:MainAxisAlignment.end,
                  children: [
                    Expanded(flex:1,child: Container(alignment:Alignment.center,child: RotatedBox(quarterTurns: 1,child:Text('مقدار الإستهلاك بالواط',style:TextStyle(fontSize:12))))),
                    Text('الأجهزة',style:TextStyle(fontSize:12)),
                  ])

            ],
          ),
        ),
      ),
    );
  }
}
