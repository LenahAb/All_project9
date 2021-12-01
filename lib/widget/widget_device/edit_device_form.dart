import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/custom_form_field.dart';
import 'package:log_in/utils/utils_device/databaseDevice.dart';
import 'package:log_in/utils/validator.dart';



class EditDeviceForm extends StatefulWidget {
  final FocusNode nameDeviceFocusNode;
 // final FocusNode typeDeviceFocusNode;
  final String currentNameDevice;
  //final String currentTypeDevice;
  final String documentId;

  const EditDeviceForm({
    required this.nameDeviceFocusNode,
   // required this.typeDeviceFocusNode,
    required this.currentNameDevice,
    //required this.currentTypeDevice,
    required this.documentId,
  });

  @override
  _EditDeviceFormState createState() => _EditDeviceFormState();
}

class _EditDeviceFormState extends State<EditDeviceForm> {
  final _editDeviceFormKey = GlobalKey<FormState>();
  var typeDevice ;
  var setDefaultMake = true, setDefaultMakeModel = true;

  bool _isProcessing = false;

  late TextEditingController _nameDeviceController;


  @override
  void initState() {
    _nameDeviceController = TextEditingController(
      text: widget.currentNameDevice,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key:_editDeviceFormKey,
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
                  controller: _nameDeviceController,
                  focusNode: widget.nameDeviceFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  obscureText: false,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'أسم الجهاز',
                  hint: 'أدخل أسم الجهاز',
                ),




                SizedBox(height: 24.0),
                 Text(
                ': نوع الجهاز',
                style: TextStyle(color: Colors.black, fontSize: 19.0, letterSpacing: 1,),
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
                        ),
                        );
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
                widget.nameDeviceFocusNode.unfocus();
               // widget.typeDeviceFocusNode.unfocus();

                if (_editDeviceFormKey.currentState!.validate()) {
                  setState(() {
                    _isProcessing = true;
                  });

                  await DatabaseDevice.updateDevice(
                    docId: widget.documentId,
                    nameDevice: _nameDeviceController.text,
                    typeDevice: typeDevice,
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