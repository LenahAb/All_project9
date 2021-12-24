import 'package:flutter/material.dart';
import 'package:group3/utils/background_image_widget.dart';
import 'package:group3/widget/widget_device/edit_device_form.dart';


class EditDeviceScreen extends StatefulWidget {
  final String currentNameDevice;
  final currentTypeDevice;
  final String documentId;

  EditDeviceScreen({
    required this.currentNameDevice,
    required this.currentTypeDevice,
    required this.documentId,
  });

  @override
  _EditDeviceScreenState createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  final FocusNode _nameDeviceFocusNode = FocusNode();

  final FocusNode _typeDeviceFocusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),

    child:GestureDetector(
      onTap: () {
        _nameDeviceFocusNode.unfocus();
        _typeDeviceFocusNode.unfocus();
      },
      child:Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('تعديل معلومات الجهاز',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,
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
            child: EditDeviceForm(
              documentId: widget.documentId,
              nameDeviceFocusNode: _nameDeviceFocusNode,
              typeDeviceFocusNode: _typeDeviceFocusNode,
              currentNameDevice: widget.currentNameDevice,
              currentTypeDevice: widget.currentTypeDevice,
            ),
          ),
        ),
      ),
    ),
    );
  }
}
