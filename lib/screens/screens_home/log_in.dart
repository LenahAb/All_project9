import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_building/list_building_screen.dart';
import 'package:log_in/utils/fire_auth.dart';
import 'package:log_in/utils/validator.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/utils/custom_form_field.dart';
import 'forgot_password.dart';

class LogIn extends StatefulWidget {
  @override
  _LogIn createState() => _LogIn();

}

class _LogIn extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ListBuildingScreen(user: user,),
        ),
      );
  }
    return firebaseApp;
  }
  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),

      child:GestureDetector(
      onTap: () {
      _focusEmail.unfocus();
      _focusPassword.unfocus();
      },


      child:Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
              leading: BackButton(
                  color: Color(0xFF535353)
              ),
            backgroundColor: Color(0xFFF5F8FA),
          ),




          body: FutureBuilder(future: _initializeFirebase(), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child:SingleChildScrollView(
              child:Column(
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 25.0),
                      Padding(padding: EdgeInsets.only(left: 150.0,top: 40.0),
                        child: Text(' تسجيل الدخول',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),
                      ),
                      Padding(padding: EdgeInsets.only(left:140.0, ),
                        child: Text('من فضلك ادخل معلومات حسابك',style: TextStyle(fontSize: 15, color: Colors.grey[700], letterSpacing: 2,),),
                      ),],
                  ),

                  Form(
                    key: _formKey,

                    child: Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      height: 90.0,
                       child: CustomFormField(
                         isLabelEnabled: true,
                  controller: _emailTextController,
                  focusNode: _focusEmail,
                  keyboardType: TextInputType.emailAddress,
                   obscureText:false,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),

                  label: 'البريد الالكتروني',
                  hint: 'أدخل البريد الالكتروني',

                ),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        height: 90.0,
                     child:CustomFormField(
                       isLabelEnabled: true,
                       controller: _passwordTextController,
                       focusNode: _focusPassword,
                       keyboardType: TextInputType.text,
                       obscureText: true,
                       inputAction: TextInputAction.done,
                       validator: (value) => Validator.validatePassword(
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








                  Padding(padding: EdgeInsets.only(left: 150.0,bottom: 40.0 ),

                    child: TextButton(
                      child: Text('نسيت كلمة المرور ؟',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[700], letterSpacing: 2,),),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },),
                  ),


                  _isProcessing ? CircularProgressIndicator() :
                  Center(child:
                  Padding(padding: EdgeInsets.only(left: 40.0, right: 40.0,),

                    child: Container(width: double.maxFinite,

                      child:Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF0390C3)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),),

                        onPressed: () async{_focusEmail.unfocus();
                        _focusPassword.unfocus();

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isProcessing = true;
                          });
                          try {
                            User? user = await FireAuth
                                .signInUsingEmailPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,);

                            if (user != null) {
                              Navigator.of(context)
                                  .pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => ListBuildingScreen(user: user),


                                      //ProfilePage(user: user),
                                ),
                              );
                            }
                          }on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                print("No user found for that email");
                                ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                backgroundColor: Colors.red[400],
                                  duration: Duration(seconds: 15),
                                  //behavior: SnackBarBehavior.floating,
                                 // width: 300,
                                  //padding: EdgeInsets.only(right: 30.0),
                                  action: SnackBarAction(
                                      label: 'X',
                                      textColor: Colors.black,
                                      onPressed: () {
                                      }),
                                 content: Text(
                                 "لم يتم العثور على مستخدم لهذا البريد الإلكتروني",
                                 //'لم يتم العثور على المستخدم '
                                 style: TextStyle(
                                   fontSize: 18.0, color: Colors.white,),
                                   textAlign: TextAlign.right,
                                  ),),);

                                 } else if (e.code == 'wrong-password') {
                                    print("Wrong password provided");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                      backgroundColor: Colors.red[400],
                                        duration: Duration(seconds: 15),
                                        //padding: EdgeInsets.only(right: 30.0),
                                        action: SnackBarAction(
                                            label: 'X',
                                            textColor: Colors.black,
                                            onPressed: () {
                                            }),
                                      content: Text(
                                      "كلمة المرور المدخلة غير صحيحة",
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white,), textAlign: TextAlign.right,
                                      ),),);


                                }else if (e.code == 'error_user_disabled') {
                                  print("User with this email has been disabled");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red[400],
                                      duration: Duration(seconds: 15),
                                      //padding: EdgeInsets.only(right: 30.0),
                                      action: SnackBarAction(
                                          label: 'X',
                                          textColor: Colors.black,
                                          onPressed: () {
                                          }),
                                      content: Text(
                                        "تم تعطيل المستخدم لهذا البريد الإلكتروني ",
                                        style: TextStyle(
                                            fontSize: 18.0, color: Colors.white), textAlign: TextAlign.right,
                                      ),),);


                                } else if (e.code == 'error_operation_not_allowed') {
                                  print("Signing in with Email and Password is not enabled");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red[400],
                                      duration: Duration(seconds: 15),
                                      //padding: EdgeInsets.only(right: 30.0),
                                      action: SnackBarAction(
                                          label: 'X',
                                          textColor: Colors.black,
                                          onPressed: () {
                                          }),
                                      content: Text(
                                        "لم يتم تمكين تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور",
                                        style: TextStyle(
                                            fontSize: 18.0, color: Colors.white), textAlign: TextAlign.right,
                                      ),),);


                                } else if (e.code == 'error_too_many_requests') {
                                  print("Too many requests. Try again later");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red[400],
                                      duration: Duration(seconds: 15),
                                      //padding: EdgeInsets.only(right: 30.0),
                                      action: SnackBarAction(
                                          label: 'X',
                                          textColor: Colors.black,
                                          onPressed: () {
                                          }),
                                      content: Text(
                                        "طلبات كثيرة جدا. حاول مرة أخرى في وقت لاحق",
                                        style: TextStyle(
                                            fontSize: 18.0, color: Colors.white), textAlign: TextAlign.right,
                                      ),),);
                                }
                          } catch (e) {
                            print(e); }

                            setState(() {
                              _isProcessing = false;
                            });
                        }



                        },

                        child: Padding(padding: EdgeInsets.only(top: 16.0, bottom: 16.0), child: Text('تسجيل الدخول',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2,
                        ),),
                        ),
                      ),
                    ),
                  ),
                  ),
                  ),


                ],
              )


),
          );
        }

           return Center(
              child: CircularProgressIndicator(),
        );
      },
      ),


      ),
      ),
    );





  }
}