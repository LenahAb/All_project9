import 'package:flutter/material.dart';
import 'package:group3/utils/background_image_widget.dart';
import 'package:group3/widget/widget_device/edit_Smart_form.dart';




class EditSmartScreen extends StatefulWidget {
  final String currentNameSmart;
  final String documentId;

  EditSmartScreen({
    required this.currentNameSmart,
    required this.documentId,
  });

  @override
  _EditSmartScreenState createState() => _EditSmartScreenState();
}

class _EditSmartScreenState extends State<EditSmartScreen> {
  final FocusNode _nameSmartFocusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),

      child:GestureDetector(
        onTap: () {
          _nameSmartFocusNode.unfocus();
        },
        child:Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text('تعديل معلومات القابس الذكي',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,
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
              child: EditSmartForm(
                documentId: widget.documentId,
                plugNameFocusNode: _nameSmartFocusNode,
                currentNameSmartPlug: widget.currentNameSmart,

              ),
            ),
          ),
        ),
      ),
    );
  }
}
