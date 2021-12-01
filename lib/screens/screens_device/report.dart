import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/utils/utils_device/device_data.dart';
import 'package:log_in/utils/utils_device/month_model.dart';



class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool loading = true;

  // put data for chart
  List<ReportSeries> data = [];
  List<MonthModel> monthModel = [];

  // put data to the chosen month for chart

  // give the chart for ths chosen month
  Future<void> addGraph(String monthValue) async {
    setState(() {
      data = [];
    });

    for(DeviceData element in deviceData) {
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
              barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
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
    await FirebaseFirestore.instance.collection('Building').get().then((value) {
      if (value.docs.isNotEmpty) {
        QueryDocumentSnapshot snap = value.docs.first;
        snap.reference.collection('MonthlyConsumption').get().then((v) {
          if (v.docs.isNotEmpty) {
            v.docs.forEach((item) {
              itsMonthName.add(item.id);
              monthModel.add(
                  MonthModel(consumption: item['amount'], cost: item['cost']));
            });

            itsMonthName.sort();
            dropValue = itsMonthName.last;
            fullAmount = monthModel.last.consumption;
            fullCost = monthModel.last.cost;
            loading = false;
             addGraph(dropValue.toString()).then((_) {
              setState(() {});
            });
           

            
          } else {
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  String docName = '';

  // put the last 4 months of the year in the drop down
  List itsMonthName = [];

  // put devices name & id in list
  List<DeviceData> deviceData = [];

  // get devices names and IDs
  void getDevicesNames() async {
    await FirebaseFirestore.instance.collection('Device').get().then((value) {
      value.docs.forEach((element) {
        deviceData
            .add(DeviceData(id: element.id, name: element['device_name']));
      });

      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevicesNames();
    getMonthsData();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),

    child:Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
            color: Color(0xFF535353)
        ),
        backgroundColor: Color(0xFFF5F8FA),
        centerTitle: true,
        title: Text('التقرير',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          const Text(
                            'الاستهلاك الشهري لأجهزة المبنى',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            // textDirection: TextDirection.rtl
                          ),
                          DropdownButton(
                            value: dropValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            items: itsMonthName.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              dropValue = newValue;
                              print(dropValue);

                              addGraph(dropValue.toString()).then((_) {
                                setState(() {});
                              });

                              //  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Report()));
                            },
                          ),
                          Container(
                            height: 250,
                            child: ReportChart(
                              data: data,
                            ),
                          ),
                          Container(
                            height: 2,
                            color: Colors.grey[300],
                          ),
                          /* Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('كمية الاستهلاك'),
                              Text('اسم الجهاز'),
                            ],
                          ),
                          Container(
                            height: 2,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          displayMap(chartMap),
                        ],
                      ),
                    ),*/
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('الاستهلاك الشهري لأجهزة المبنى',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textDirection: TextDirection.rtl),
                          Container(
                            height: 2,
                            color: Colors.grey[300],
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
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('تكلفة الاستهلاك الشهري للمبنى',
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
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: charts.BarChart(
            series,
            animate: true,
            animationDuration: Duration(milliseconds: 100),
          ),
        ),
      ),
    );
  }
}
