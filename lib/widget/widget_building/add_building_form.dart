import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group3/screens/screens_building/list_building_screen.dart';
import 'package:group3/utils/databaseBuilding.dart';
import 'package:group3/utils/validator.dart';

import '../../utils/custom_form_field.dart';

class AddBuildingForm extends StatefulWidget {
  final FocusNode nameBuildingFocusNode;
  final FocusNode typeBuildingFocusNode;
  final User user;

  const AddBuildingForm({
    required this.nameBuildingFocusNode,
    required this.typeBuildingFocusNode,
    required this.user,
  });

  @override
  _AddDeviceForm createState() => _AddDeviceForm();
}

class _AddDeviceForm extends State<AddBuildingForm> {
  final _addBuildingFormKey = GlobalKey<FormState>();
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
    'حكومي',
    'زراعي',
    'خيري',
    'خاص',
  ];
  var _selectedFruit=  "سكني";
  var setDefaultMake = true, setDefaultMakeModel = true;
  var c;




  final TextEditingController _nameBuildingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addBuildingFormKey,
      child:SingleChildScrollView(
      child: Column(
        children: [
          /*Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [


               Padding(padding: EdgeInsets.only(left: 230.0,top: 60.0),
                  child: Text(' إضافة مبنى',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),
                ),
              ]),*/
      Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 24.0,top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 24.0),
                Text(
                  ': أسم المبنى',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 19.0, letterSpacing: 1,),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _nameBuildingController,
                  focusNode: widget.nameBuildingFocusNode,
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
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 19.0, letterSpacing: 1,
                  ),
                ),



                SizedBox(height: 8.0),


                //  InputDecorator(
                //    decoration: InputDecoration(

                // labelStyle: Theme.of(context).primaryTextTheme.caption!.copyWith(color: Colors.black),
                //    enabledBorder: const OutlineInputBorder(
                //      borderSide: BorderSide(color: Colors.grey,width: 1.0)),
                //  ),


                 //child: DropdownButtonHideUnderline(


        Container(padding:  EdgeInsets.symmetric(horizontal: 10, vertical:15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black38, width:1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
            child:  DropdownButton(
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

                  value: _selectedFruit ,
                items: BuildingType.map((item) {

                    return DropdownMenuItem(
                        value: item,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child:  Text(item,style: TextStyle(fontSize: 16),),

                        ));
                  }).toList(),
                  onChanged: (selectedItem) => setState(() {

                    _selectedFruit = selectedItem.toString();



                    }
                  ),
                  //hint:Text("                                                                                     "),

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
                  widget.nameBuildingFocusNode.unfocus();
                  widget.typeBuildingFocusNode.unfocus();

                  if (_addBuildingFormKey.currentState!.validate()) {
                    setState(() { _isProcessing = true;});
                    print(
                      'hgggggggggggggggggggggggggg'
                    );



                  /*c =  FirebaseFirestore.instance.collection("Building").where("building_owner_id", isEqualTo:'BuildingOwner/'+_IdUser.uid).snapshots();
                     c.get().then((QuerySnapshot snapshot) {
                     snapshot.docs.forEach((DocumentSnapshot doc) {
                      if (doc["building_name"] == _nameBuildingController.text ){
                        print(
                            'h33333333333333'
                        );
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
                     });});
                    print(
                        'h2222222222222222222222222'
                    );*/

                      await DatabaseBuilding.addBuilding(
                        nameBuilding: _nameBuildingController.text,
                        typeBuilding: _selectedFruit,
                        buildingOwnerId: _IdUser.uid,);



                 setState(() {
                        _isProcessing = false;
                      });

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ListBuildingScreen(user: _IdUser)
                      ),
                      );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.lightGreen,
                        content: Text(
                          "تم إضافة المبنى بنجاح",
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );

                    }
                    /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orangeAccent,
                        content: Text(
                          'اسم المبنى مكرر! ',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );*/



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
       .where('building_name', isNotEqualTo:_nameBuildingController.text);
   return true;
 }
}
