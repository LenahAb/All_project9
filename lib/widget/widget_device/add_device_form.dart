import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_device/list_device_smart_screen.dart';
import 'package:log_in/utils/custom_form_field.dart';
import 'package:log_in/utils/utils_device/databaseDevice.dart';
import 'package:log_in/utils/validator.dart';


class AddDeviceForm extends StatefulWidget {
  final FocusNode nameDeviceFocusNode;
  final String BuildingId;
  final User user;
  const AddDeviceForm({
    required this.nameDeviceFocusNode,
    required this.BuildingId,
    required this.user
  });

  @override
  _AddDeviceForm createState() => _AddDeviceForm();
}

class _AddDeviceForm extends State<AddDeviceForm> {
  final _addDeviceFormKey = GlobalKey<FormState>();
  var typeDevice ;
  var setDefaultMake = true, setDefaultMakeModel = true;

  bool _isProcessing = false;

  late User u;

  @override
  void initState() {
    u = widget.user ;
    super.initState();
  }


  final TextEditingController _nameDeviceController = TextEditingController();

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
            child: Text(' إضافة جهاز',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),
          ),
          ]),

          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 24.0,),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 24.0),
                Text(
                  ': أسم الجهاز',
                  style: TextStyle(color: Colors.black, fontSize: 19.0, letterSpacing: 1,),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _nameDeviceController,
                  focusNode: widget.nameDeviceFocusNode,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  inputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'أسم الجهاز',
                  hint: 'أدخل أسم الجهاز',
                ),



                SizedBox(height: 24.0),
                Text(
                  ': نوع الجهاز',
                  style: TextStyle(color: Colors.black, fontSize: 19.0, letterSpacing: 1,
                  ),
                ),


                   Center(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Type')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        // Safety check to ensure that snapshot contains data
                        // without this safety check, StreamBuilder dirty state warnings will be thrown
                        if (!snapshot.hasData) return Container();
                        // Set this value for default,
                        // setDefault will change if an item was selected
                        // First item from the List will be displayed
                        if (setDefaultMake) {
                          typeDevice = snapshot.data?.docs[0].get('type_name');
                          debugPrint('setDefault typeDevice: $typeDevice');

                        }
                        return DropdownButton(
                          dropdownColor: Colors.white,
                          style: TextStyle(color: Colors.black),
                          iconEnabledColor:Color(0xFF0390C3),
                          isExpanded: false,
                          value: typeDevice,
                          items: snapshot.data?.docs.map((value) {
                            return DropdownMenuItem(
                              value: value.get('type_name'),
                              child: Container(
                            alignment: Alignment.centerRight,
                              child: Text('${value.get('type_name')}'),
                            ),);
                          }).toList(),
                          onChanged: (value) {
                            setState(
                                  () {
                                typeDevice = value;
                                // Default dropdown value won't be displayed anymore
                                setDefaultMake = false;
                                // Set makeModel to true to display first car from list
                                setDefaultMakeModel = true;
                              },
                            );
                          },
                          hint:Text("                                                                                     "),

                        );
                      },
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


                if (_addDeviceFormKey.currentState!.validate()) {
                  setState(() { _isProcessing = true;});

                  await DatabaseDevice.addDevice(
                    nameDevice: _nameDeviceController.text,
                    typeDevice: typeDevice,
                    buildingId: widget.BuildingId,
                  );

                  setState(() {
                    _isProcessing = false;
                  });

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListDeviceSmartScreen( BuildingId:widget.BuildingId, user: u,
                       )
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
}
