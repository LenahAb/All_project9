import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_building/list_building_screen.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/utils/utils_device/navigaion.dart';
import 'package:log_in/widget/widget_device/device_list.dart';
import 'package:log_in/widget/widget_device/smart_plug_list.dart';
import 'package:tuple/tuple.dart';
import 'icon_add.dart';



class ListDeviceSmartScreen extends StatefulWidget {
  final String BuildingId;
  final User user;
  ListDeviceSmartScreen({
   required this. BuildingId,
    required this.user,
  });

  @override
  _ListDeviceSmartScreen createState() => _ListDeviceSmartScreen();
}

class _ListDeviceSmartScreen extends State<ListDeviceSmartScreen> with SingleTickerProviderStateMixin {
  late User u;

 

  late
  final List<Tuple2> _pages=[
    Tuple2('القوابس الذكية' ,SmartPlugeList(BuildingId:widget.BuildingId)),
    Tuple2 ('الأجهزة',DeviceList(BuildingId:widget.BuildingId)),

  ];
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    u = widget.user ;
    super.initState();
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }






  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 20.png"),

      child: DefaultTabController(
      length: _pages.length,
      child:Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF535353)),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ListBuildingScreen(user: u,),
                      ),
                    );
                  }
              );
            },

          ),
          backgroundColor: Color(0xFFF5F8FA),
          bottom: TabBar(
            labelColor: Colors.black,
            controller: _tabController,
            indicatorColor: Color(0xFFFFC800),

            tabs: _pages.map<Tab>((Tuple2 page) => Tab(child: Text(page.item1, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xFF0390C3)),),)).toList()
          ),
        ),


        bottomNavigationBar:SingleChildScrollView(
    child:Padding(padding: const EdgeInsets.only(right: 300.0,bottom: 20.0,),
    child:FloatingActionButton(
          backgroundColor:Color(0xFF0390C3),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IconAdd(BuildingId: widget.BuildingId, user: u,
                  ),
              ),
            ); },
          child: Icon(
            Icons.add,
            color: Colors.white,),
    ),
    ),
        ),


        body: Padding(padding: EdgeInsets.only(top: 25.0,left: 10.0, right: 10.0),
               child:TabBarView(
              controller: _tabController,
              children: _pages.map<Widget>((Tuple2 page) => page.item2).toList(),

      ),),



      ),



        ),

    );
  }


}


