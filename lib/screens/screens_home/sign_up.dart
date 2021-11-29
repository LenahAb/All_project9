import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_building/list_building_screen.dart';
import 'package:log_in/utils/fire_auth.dart';
import 'package:log_in/utils/validator.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/utils/custom_form_field.dart';

class SingUp extends StatefulWidget {
  @override
  _SingUp createState() => _SingUp();

}

class _SingUp extends State<SingUp> {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),

      child: GestureDetector(
        onTap: () {
          _focusName.unfocus();
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            leading: BackButton(
                color: Color(0xFF535353)
            ),
            backgroundColor: Color(0xFFF5F8FA),
          ),


          body: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child:SingleChildScrollView(
              child: Column(
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Padding(padding: EdgeInsets.only(left: 250.0, top: 60.0),
                        child: Text(' التسجيل', style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0390C3),
                          letterSpacing: 2,),),
                      ),
                      Padding(padding: EdgeInsets.only(left: 140.0,),
                        child: Text('من فضلك ادخل معلومات حسابك',
                          style: TextStyle(fontSize: 15,
                            color: Colors.grey[700],
                            letterSpacing: 2,),),
                      ),
                    ],
                  ),

                  Form(
                    key: _registerFormKey,
                    child:
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            height: 90.0,
                            child: CustomFormField(
                              controller: _nameTextController,
                              focusNode: _focusName,
                              keyboardType: TextInputType.name,
                              obscureText:false,
                              inputAction: TextInputAction.done,
                              validator: (value) => Validator.validateName(
                                    name: value,
                                  ),

                              label: 'أسم المستخدم',
                              hint: 'أدخل أسم المستخدم',

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            height: 90.0,
                            child: CustomFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              obscureText:false,
                              keyboardType: TextInputType.emailAddress,
                              inputAction: TextInputAction.done,
                              validator: (value) =>
                                  Validator.validateEmail(
                                    email: value,
                                  ),

                              label: 'البريد الالكتروني',
                              hint: 'أدخل البريد الالكتروني',

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 60.0),
                          child: SizedBox(
                            height: 90.0,
                            child: CustomFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText:true,
                              keyboardType: TextInputType.text,
                              inputAction: TextInputAction.done,
                              validator: (value) =>
                                  Validator.validatePassword(
                                    password: value,
                                  ),

                              label: 'كلمة المرور',
                              hint: 'أدخل كلمة المرور',

                            ),
                          ),
                        ),
                      ],
                    ),


                  ),




                  _isProcessing ? CircularProgressIndicator() :
                  Center(child:
                  Padding(padding: EdgeInsets.only(left: 40.0, right: 40.0,),

                    child: Container(width: double.maxFinite,


                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color(0xFF0390C3)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),),),),

                        onPressed: () async {
                      if (_registerFormKey.currentState!.validate()) {
                             setState(() {
                          _isProcessing = true;
                        });
                        try {
                          User? user = await FireAuth
                              .registerUsingEmailPassword(
                            name: _nameTextController.text,
                            email: _emailTextController.text,
                            password: _passwordTextController.text,
                          );
                          print(user);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.lightGreen,
                              content: Text(
                                "تم التسجيل الدخول بنجاح",
                                style: TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          );

                          if ( user != null) {
                            Navigator.of(context)
                                .pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => ListBuildingScreen(user: user),
                              ),
                              ModalRoute.withName('/'),
                            );
                          }

                         } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print("Password Provided is too Weak");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.orangeAccent,
                                duration: Duration(seconds: 10),
                                content: Text(
                                  "كلمة المرور المقدمة ضعيفة جدًا",
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                  textAlign: TextAlign.right,
                                ),),);


                          } else if (e.code == 'email-already-in-use') {
                            print("Account Already exists");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.orangeAccent,
                                duration: Duration(seconds: 40),
                                //padding: EdgeInsets.only(right: 30.0),
                                action: SnackBarAction(
                                    label: 'حسنًا',
                                    textColor: Colors.white,
                                    onPressed: () {
                                    }),
                                content:
                                Text(
                                  "الحساب موجود بالفعل ",
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                  textAlign: TextAlign.right,
                                ),),);

                          }
                        } catch (e) {
                          print(e);
                        }
                         setState(() {
                               _isProcessing = false;
                             });
                      }
                        },

                        child: Padding(padding: EdgeInsets.only(
                            top: 16.0, bottom: 16.0), child: Text(
                          'تسجيل الدخول', style: TextStyle(fontSize: 19,
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
        ),
      ),
    );
  }
}