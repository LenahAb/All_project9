import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_building/list_building_screen.dart';
import 'package:log_in/utils/databaseBuilding.dart';
import 'package:log_in/utils/validator.dart';

import '../../utils/custom_form_field.dart';

class AddBuildingForm extends StatefulWidget {
  final FocusNode nameDeviceFocusNode;
  final FocusNode typeDeviceFocusNode;
  final User user;

  const AddBuildingForm({
    required this.nameDeviceFocusNode,
    required this.typeDeviceFocusNode,
    required this.user,
  });

  @override
  _AddDeviceForm createState() => _AddDeviceForm();
}

class _AddDeviceForm extends State<AddBuildingForm> {
  final _addDeviceFormKey = GlobalKey<FormState>();

  late User _IdUser;

  @override
  void initState() {
    _IdUser = widget.user;
    super.initState();
  }

  bool _isProcessing = false;
  static const BuildingType = [
    'سكني',
    'تجاري',
    'صناعي',

  ];
  var _selectedFruit;
  late bool setDefaultMake=true;

  final TextEditingController _nameDeviceController = TextEditingController();
  final TextEditingController _typeDeviceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addDeviceFormKey,
      child:SingleChildScrollView(
      child: Column(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Padding(padding: EdgeInsets.only(left: 230.0,top: 60.0),
                  child: Text(' إضافة مبنى',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),
                ),
              ]),
      Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 24.0,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 24.0),
                Text(
                  ': أسم المبنى',
                  style: TextStyle(color: Colors.black, fontSize: 19.0, letterSpacing: 1,),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _nameDeviceController,
                  focusNode: widget.nameDeviceFocusNode,
                  obscureText:false,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'أسم المبنى',
                  hint: 'أدخل أسم المبنى',
                ),



                SizedBox(height: 24.0),
                Text(
                  ': نوع المبنى',
                  style: TextStyle(color: Colors.black, fontSize: 19.0, letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8.0),
                SizedBox(height: 8.0),

                //  InputDecorator(
                //    decoration: InputDecoration(

                // labelStyle: Theme.of(context).primaryTextTheme.caption!.copyWith(color: Colors.black),
                //    enabledBorder: const OutlineInputBorder(
                //      borderSide: BorderSide(color: Colors.grey,width: 1.0)),
                //  ),


                //child: DropdownButtonHideUnderline(

                DropdownButton(
                  isExpanded: true,



                  icon: Icon(Icons.arrow_drop_down,color: Colors.grey,),

                  dropdownColor: Colors.white,
                  isDense: true,
                  // Reduces the dropdowns height by +/- 50%

                  value: _selectedFruit,
                  items: BuildingType.map((item) {

                    return DropdownMenuItem(
                        value: item,



                        child: Container(
                          alignment: Alignment.centerRight,

                          // height: 2,


                          child:  Text(item),

                        ));
                  }).toList(),
                  onChanged: (selectedItem) => setState(() => _selectedFruit = selectedItem,
                  ),
                ),


              ],
          ),
            ),




          _isProcessing ? Padding(padding: const EdgeInsets.all(16.0), child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0390C3),),
          ),
          )

              : Center(child:
          Padding(padding: EdgeInsets.only(top: 40,left: 40.0, right: 40.0,),

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
                  widget.nameDeviceFocusNode.unfocus();
                  widget.typeDeviceFocusNode.unfocus();

                  if (_addDeviceFormKey.currentState!.validate()) {
                    setState(() { _isProcessing = true;});

                    if (AddName() == true) {
                      await DatabaseBuilding.addBuilding(
                        nameDevice: _nameDeviceController.text,
                        typeDevice: _selectedFruit,
                        userUid: _IdUser.uid,);


                 setState(() {
                        _isProcessing = false;
                      });

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ListBuildingScreen(user: _IdUser)
                      ),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orangeAccent,
                        content: Text(
                          'اسم المبنى مكرر! ',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );


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

 Future<bool> AddName () async {

   FirebaseFirestore.instance.collection("Building")
       .where('building_name', isNotEqualTo:_nameDeviceController.text);
   return true;
 }
}
