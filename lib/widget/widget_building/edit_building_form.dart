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

  ];
  var _selectedFruit;

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
          Padding(padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 24.0,top: 100.0),

            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 24.0),
                Text(': أسم المبنى',
                  style: TextStyle(color: Colors.black, fontSize: 19.0, letterSpacing: 1,),),
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
                  style: TextStyle(color: Colors.black, fontSize: 19.0, letterSpacing: 1,),
                ),
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
