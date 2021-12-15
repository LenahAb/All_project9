import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/widget/widget_device/add_device_form.dart';


class AddDeviceScreen extends StatefulWidget {
  final String BuildingId;
  final User user;

  AddDeviceScreen({
    required this. BuildingId,
    required this.user
 });


  @override
  _AddDeviceScreen createState() => _AddDeviceScreen();}

class _AddDeviceScreen extends State<AddDeviceScreen> {
  final FocusNode _nameDevice = FocusNode();
  final FocusNode _typeDevice = FocusNode();

  late User _IdUser;

  @override
  void initState() {
    _IdUser = widget.user ;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),

         child:GestureDetector(
          onTap: () {
            _nameDevice.unfocus();
             _typeDevice.unfocus();},

         child:Scaffold(
            backgroundColor: Colors.transparent,
               appBar: AppBar(
                 elevation: 0,
                 centerTitle: true,
                 title: Text('إضافة جهاز',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,
                 ),),
                leading: BackButton(
                color: Color(0xFF535353)
                        ),
                    backgroundColor: Color(0xFFF5F8FA),
                  ),


         body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: AddDeviceForm(
              nameDeviceFocusNode: _nameDevice,
              BuildingId: widget.BuildingId,
              user: _IdUser,
            ),
          ),
        ),
      ),
       ),
    );
  }
}
