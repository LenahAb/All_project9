import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/validator.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/utils/custom_form_field.dart';
import 'package:log_in/widget/widget_home/edit_name_form.dart';
import 'package:log_in/widget/widget_home/edit_password_form.dart';





class EditPassword extends StatefulWidget {
  final User user;
  const EditPassword({
    required this.user,});

  @override
  _EditPasswordState createState() => _EditPasswordState();

}

class _EditPasswordState extends State<EditPassword> {
  final FocusNode _FocusNodePassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 20.png"),

      child: GestureDetector(
        onTap: () {

          _FocusNodePassword.unfocus();
        },

        child:Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text('تعديل كلمة المرور ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,
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
              child: EditPasswordForm(
                FocusNodePassword: _FocusNodePassword,
                user: widget.user, ),
            ),
          ),
        ),
      ),
    );
  }

}