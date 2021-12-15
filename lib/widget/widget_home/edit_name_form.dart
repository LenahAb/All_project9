import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_home/profile_page.dart';
import 'package:log_in/utils/fire_auth.dart';
import 'package:log_in/utils/validator.dart';
import 'package:log_in/utils/custom_form_field.dart';





class EditNameForm extends StatefulWidget {
  final FocusNode FocusNodeName;
  final User user;
  const EditNameForm({
    required this.user,required this.FocusNodeName,
  });

  @override
  _EditNameFormState createState() => _EditNameFormState();

}

class _EditNameFormState extends State<EditNameForm> {
  final _registerFormKey = GlobalKey<FormState>();
  late final TextEditingController controller;
  final newPasswordController = TextEditingController();

  void initState() {
    super.initState();
    controller= TextEditingController(text: widget.user.displayName);
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child:Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child:SingleChildScrollView(
              child: Column(
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Padding(padding: EdgeInsets.only(left: 150.0, top: 150.0),
                        child: Text(': تعديل الأسم', style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0390C3),
                          letterSpacing: 2,),),
                      ),
                    ],
                  ),

                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            height: 90.0,
                            child: CustomFormField(
                              isLabelEnabled: true,
                              controller: controller,
                              focusNode: widget.FocusNodeName,
                              keyboardType: TextInputType.name,
                              obscureText:false,
                              inputAction: TextInputAction.done,
                              validator: (value) => Validator.validateName(
                                name: value,
                              ),

                              label: 'أسم المستخدم الجديد',
                              hint: 'أدخل أسم المستخدم الجديد',

                            ),
                          ),
                        ),


                      ],
                    ),







                  _isProcessing ? CircularProgressIndicator() :
                  Center(child:
                  Padding(padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 70),

                    child: Container(width: double.maxFinite,


                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color(0xFF0390C3)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),),),),

                        onPressed: () async {
                          widget.FocusNodeName.unfocus();

                          if (_registerFormKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                            });


                        try{
                            User? user = await FireAuth.UpdateName(
                              name:controller.text,
                            );


                            if (user != null) {
                              Navigator.of(context)
                                  .pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage (user: user),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.lightGreen,
                                  duration: Duration(seconds: 4),
                                  content: Text(
                                    'تم تحديث الاسم بنجاح',
                                    style: TextStyle(fontSize: 18.0),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              );
                            }

                        } catch (e) {}

                            setState(() {
                              _isProcessing = false;
                            });
                          }
                        },

                        child: Padding(padding: EdgeInsets.only(
                            top: 16.0, bottom: 16.0), child: Text(
                          'حفظ', style: TextStyle(fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),),
                        ),
                      ),
                    ),
                  ),
                  ),


                ],
              )


          ),

      ),

    );
  }



}