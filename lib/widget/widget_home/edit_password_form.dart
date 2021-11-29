import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_home/log_in.dart';
import 'package:log_in/utils/fire_auth.dart';
import 'package:log_in/utils/validator.dart';
import 'package:log_in/utils/custom_form_field.dart';





class EditPasswordForm extends StatefulWidget {
  final FocusNode FocusNodePassword;
  final User user;
  const EditPasswordForm({
    required this.user,required this.FocusNodePassword,
  });

  @override
  _EditPasswordFormState createState() => _EditPasswordFormState();

}

class _EditPasswordFormState extends State<EditPasswordForm> {
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

                  Padding(padding: EdgeInsets.only(left: 165.0, top: 150.0),
                    child: Text(': تعديل كلمة المرور', style: TextStyle(
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
                      child:CustomFormField(
                        controller: newPasswordController,
                        focusNode: widget.FocusNodePassword,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        inputAction: TextInputAction.done,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),

                        label: 'كلمة المرور الجديدة',
                        hint: 'أدخل كلمة المرور الجديدة',

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
                      widget.FocusNodePassword.unfocus();

                      if (_registerFormKey.currentState!.validate()) {
                        setState(() {
                          _isProcessing = true;
                        });
                       try {
                        User? user = await FireAuth.UpdatePassword(
                            password: newPasswordController.text);
                        await FirebaseAuth.instance.signOut();

                        if (user != null) {

                          Navigator.of(context)
                              .pushReplacement(
                              MaterialPageRoute(builder: (context) => LogIn()
                            ),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.lightGreen,
                            content: Text(
                             // 'Your Password has been Changed. Login again !',
                              'تم تغيير كلمة السر الخاصة بك، سجل الدخول مرة أخرى ',
                              style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.right,
                            ),
                          ),
                        );
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