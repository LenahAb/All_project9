import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/databaseBuilding.dart';
import 'package:log_in/utils/validator.dart';


import '../../utils/custom_form_field.dart';

class EditBuildingForm extends StatefulWidget {
  final FocusNode nameDeviceFocusNode;
  final FocusNode typeDeviceFocusNode;
  final String currentNameDevice;
  final String currentTypeDevice;
  final String documentId;

  const EditBuildingForm({
    required this.nameDeviceFocusNode,
    required this.typeDeviceFocusNode,
    required this.currentNameDevice,
    required this.currentTypeDevice,
    required this.documentId,
  });

  @override
  _EditBuildingFormState createState() => _EditBuildingFormState();
}

class _EditBuildingFormState extends State<EditBuildingForm> {
  final _editDeviceFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  static const BuildingType = [
    'سكني',
    'تجاري',
    'صناعي',
    'حكومي',
    'زراعي',
    'خيري',
    'خاص',
  ];

 // late var c =FirebaseFirestore.instance.collection("Building").where("building_id", isEqualTo: widget.documentId).snapshots();
  //var r= data?.docs.get('type');

  var _selectedFruit;

  var setDefaultMake = true, setDefaultMakeModel = true;

  late TextEditingController _nameDeviceController;
  late TextEditingController _typeDeviceController;

  @override
  void initState() {
    _nameDeviceController = TextEditingController(
      text: widget.currentNameDevice,
    );

    _typeDeviceController = TextEditingController(
      text: widget.currentTypeDevice,
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
        /* Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Padding(padding: EdgeInsets.only(left: 140.0,top: 60.0),
                  child: Text(' تعديل معلومات المبنى',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),
                ),
              ]),*/
          Padding( padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 24.0,top: 100),

            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 24.0),
                Text(': أسم المبنى',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 19.0, letterSpacing: 1,),),
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
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 19.0, letterSpacing: 1,),
                ),




                SizedBox(height: 8.0),
            Container(padding:  EdgeInsets.symmetric(horizontal: 10, vertical:15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width:1),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                      child: StreamBuilder<QuerySnapshot>(
                         stream:FirebaseFirestore.instance.collection("Building").where("building_id", isEqualTo: widget.documentId).snapshots(),
                       builder: (BuildContext context,
                             AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (!snapshot.hasData) return Container();

                         if (setDefaultMake) {
                               _selectedFruit = snapshot.data?.docs[0].get('type');
                           //debugPrint('setDefault typeDevice: $_selectedFruit');

                       }


             return DropdownButton(
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                  iconEnabledColor:Color(0xFF0390C3),
                  isExpanded: true,
                  isDense: true,
                  iconSize: 34,
                  underline: Container(),
                  /*
                  icon: Icon(Icons.arrow_drop_down,color: Colors.grey,),

                  dropdownColor: Colors.white,*/

                  value: _selectedFruit,
                  items: BuildingType.map((item) {
                    return DropdownMenuItem(
                        value: item,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child:  Text(item,style: TextStyle(fontSize: 16),),

                        ));
                  }).toList(),
                          onChanged: (selectedItem) {
                          setState(() {_selectedFruit = selectedItem;

                            setDefaultMake = false;

                            setDefaultMakeModel = true;
                                           },
                                    );}


                );
    },
    ),
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
              : Padding(padding: EdgeInsets.only(top: 60,left: 40.0, right: 40.0,),

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
                  widget.typeDeviceFocusNode.unfocus();

                  if (_editDeviceFormKey.currentState!.validate()) {
                    setState(() {
                      _isProcessing = true;
                    });

                    await DatabaseBuilding.updateBuilding(
                      docId: widget.documentId,
                      nameBuilding: _nameDeviceController.text,
                      typeBuilding: _selectedFruit,
                    );

                    setState(() {
                      _isProcessing = false;
                    });

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.lightGreen,
                        content: Text(
                          "تم تعديل معلومات المبنى بنجاح",
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
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
