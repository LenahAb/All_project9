import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/widget/widget_building/add_building_form.dart';

class AddBuildingScreen extends StatefulWidget {
  final User user;
   const AddBuildingScreen({required this.user});

  @override
  _AddBuildingScreenState createState() => _AddBuildingScreenState();


}

class _AddBuildingScreenState extends State<AddBuildingScreen> {
  final FocusNode _nameDevice = FocusNode();
  final FocusNode _typeDevice = FocusNode();



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
              child: AddBuildingForm(
                nameDeviceFocusNode: _nameDevice,
                typeDeviceFocusNode: _typeDevice,
                user: widget.user,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
