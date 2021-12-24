import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group3/screens/screens_device/list_device_smart_screen.dart';
import 'package:group3/utils/custom_form_field.dart';
import 'package:group3/utils/utils_device/databaseSmart.dart';
import 'package:group3/utils/utils_device/navigaion.dart';
import 'package:group3/utils/validator.dart';




class AddSmartForm extends StatefulWidget {
  final FocusNode plugNameFocusNode;
  final String BuildingId;
  final User user;
  const AddSmartForm({
    required this. plugNameFocusNode,
    required this.BuildingId,
    required this.user
  });

  @override
  _AddSmartForm createState() => _AddSmartForm();
}

class _AddSmartForm extends State<AddSmartForm> {
  final _addSmartFormKey = GlobalKey<FormState>();
  final FocusNode plugKeyFocusNode = FocusNode();
  bool _isProcessing = false;

  late User _IdUser;

  @override
  void initState() {
    _IdUser = widget.user ;
    super.initState();
  }


  final TextEditingController _plugNameController = TextEditingController();
  final TextEditingController _plugKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addSmartFormKey,
        child:SingleChildScrollView(
      child: Column(
        children: [
         /* Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Padding(padding: EdgeInsets.only(left: 170.0,top: 60.0),
                  child: Text(' إضافة قابس ذكي',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),
                ),
              ]),*/

          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 24.0,top: 100),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 24.0),
                Text(
                  ': أسم القابس الذكي  ',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 19.0, letterSpacing: 1,),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _plugNameController,
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
                SizedBox(height: 24.0),
                Text(
                  ': رمز القابس الذكي  ',
                  style: TextStyle(
                    color: Colors.black,fontWeight: FontWeight.bold,fontSize: 19.0,letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _plugKeyController,
                  focusNode: plugKeyFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  obscureText: false,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'رمز القابس الذكي',
                  hint: 'أدخل رمز القابس الذكي',
                ),


              ],
            ),
          ),




          _isProcessing ? Padding(padding: const EdgeInsets.all(16.0), child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0390C3),),
          ),
          )

              : Center(child:
          Padding(padding: EdgeInsets.only(top: 60,left: 40.0, right: 40.0,),

            child:Container(width: double.maxFinite,

              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(0xFF0390C3),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  widget.plugNameFocusNode.unfocus();


                  if (_addSmartFormKey.currentState!.validate()) {
                    setState(() { _isProcessing = true;});

                    await FirebaseFirestore.instance.collection('SmartPlug').doc(_plugKeyController.text).get().then((value) async {
                      if (value.exists) {
                         setState(() {
                         _isProcessing = false;});
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                         backgroundColor: Colors.red,
                           duration: Duration(seconds: 2),
                           content: Text(
                             'القابس موجود بالفعل', style: TextStyle(fontSize: 18.0,color:Colors.white), textAlign: TextAlign.right,),),);


                      } else {
                    await DatabaseSmartPlug.addSmart(
                      nameSmart_plug: _plugNameController.text,
                      keySmart_plug: _plugKeyController.text,
                      buildingId: widget.BuildingId,
                    );

                    setState(() {
                      _isProcessing = false;
                    });

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Navigation(BuildingId: widget.BuildingId, user:_IdUser,)
                    ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.lightGreen,
                        content: Text(
                          "تم إضافة القابس الذكي بنجاح",
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );

                   }
                  });

                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'إضافة',
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
          ),
        ],
      ),
        ),
    );
  }
}
