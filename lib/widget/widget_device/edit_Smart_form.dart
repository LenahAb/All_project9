import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/custom_form_field.dart';
import 'package:log_in/utils/utils_device/databaseSmart.dart';
import 'package:log_in/utils/validator.dart';




class EditSmartForm extends StatefulWidget {
  final FocusNode plugNameFocusNode;
  final String currentNameSmartPlug;
  final String documentId;

  const EditSmartForm({
    required this.plugNameFocusNode,
    required this.currentNameSmartPlug,
    required this.documentId,
  });

  @override
  _EditSmartFormState createState() => _EditSmartFormState();
}

class _EditSmartFormState extends State<EditSmartForm> {
  final _editSmartFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  late TextEditingController _nameSmartController;


  @override
  void initState() {
    _nameSmartController = TextEditingController(
      text: widget.currentNameSmartPlug,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key:_editSmartFormKey,
        child:SingleChildScrollView(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 24.0,top: 100.0),

            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 24.0),
                Text(': أسم الجهاز',
                  style: TextStyle(color: Colors.black, fontSize: 19.0, letterSpacing: 1,),),
                SizedBox(height: 8.0),

                CustomFormField(
                  isLabelEnabled: false,
                  controller: _nameSmartController,
                  focusNode: widget.plugNameFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  obscureText: false,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'أسم القابس الذكي',
                  hint: 'أدخل أسم القابس الذكي',
                ),
              ],
            ),
          ),





          _isProcessing
              ? Padding(padding: const EdgeInsets.all(16.0), child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0390C3),),
          ),
          )
              : Padding(padding: EdgeInsets.only(top: 40,left: 40.0, right: 40.0,),

            child:Container(width: double.maxFinite,



              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF0390C3),),

                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  widget.plugNameFocusNode.unfocus();

                  if (_editSmartFormKey.currentState!.validate()) {
                    setState(() {
                      _isProcessing = true;
                    });

                    await DatabaseSmartPlug.updateSmart(
                      docId: widget.documentId,
                      nameSmart_plug: _nameSmartController.text,
                    );

                    setState(() {
                      _isProcessing = false;
                    });

                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'تعديل',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
        ),
    );
  }
}
