import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/widget/widget_device/add_smart_form.dart';


class AddSmartScreen extends StatefulWidget {
  final String BuildingId;
  final User user;
  AddSmartScreen({
    required this. BuildingId,
    required this.user
  });

  @override
  _AddSmartScreen createState() => _AddSmartScreen();}

class _AddSmartScreen extends State<AddSmartScreen> {
  final FocusNode _nameSmart = FocusNode();

  late User u;

  @override
  void initState() {
    u = widget.user ;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),

      child:GestureDetector(
        onTap: () {
          _nameSmart.unfocus();},

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
              child: AddSmartForm(
                plugNameFocusNode:  _nameSmart,
                BuildingId: widget.BuildingId, user: u,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
