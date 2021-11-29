import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/widget/widget_home/edit_name_form.dart';





class EditName extends StatefulWidget {
  final User user;
  const EditName({
    required this.user,});

  @override
  _EditNameState createState() => _EditNameState();

}

class _EditNameState extends State<EditName> {
  final FocusNode _FocusNodeName = FocusNode();
  final FocusNode _FocusNodePassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage("assets/Colorized Register&Login v2 – 20.png"),

    child: GestureDetector(
      onTap: () {
        _FocusNodeName.unfocus();
        //_FocusNodePassword.unfocus();
      },

    child:Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
    title: Text('تعديل الأسم',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,
    ),),
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
    child: EditNameForm(
     FocusNodeName: _FocusNodeName,
     user: widget.user, ),
    ),
    ),
    ),
    ),
    );
  }

}