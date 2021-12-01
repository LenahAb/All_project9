import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utils/fire_auth.dart';
import 'package:log_in/utils/validator.dart';
import 'package:log_in/utils/background_image_widget.dart';
import 'package:log_in/utils/custom_form_field.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  final _emailTextController = TextEditingController();

  final _focusEmail = FocusNode();


  bool _isProcessing = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      image: AssetImage("assets/Colorized Register&Login v2 – 19.png"),

      child:GestureDetector(
        onTap: () {
          _focusEmail.unfocus();
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




          body:  Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),

                  child:Column(
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: 25.0),
                          Padding(padding: EdgeInsets.only(left: 160.0,top: 60.0),
                            child: Text(' نسيت كلمة المرور',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,),),
                          ),
                          Padding(padding: EdgeInsets.only(left:20.0, ),
                            child: Text('نحتاج لبريدك الالكتروني لإرسال رابط إعادة تعيين كلمة المرور',style: TextStyle(fontSize: 15, color: Colors.grey[700], letterSpacing: 2,),),
                          ),],
                      ),

                      Form(
                        key: _formKey,
                        child:
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: SizedBox(
                                height: 90.0,
                                child: CustomFormField(
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

                          ],
                        ),


                      ),









                      _isProcessing ? CircularProgressIndicator() :
                      Center(child:
                      Padding(padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 40.0),

                        child: Container(width: double.maxFinite,

                          child:Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF0390C3)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),),

                              onPressed: () async{_focusEmail.unfocus();

                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessing = true;
                                });
                                try {
                                 await FireAuth.ResetPassword(email: _emailTextController.text,);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.lightGreen,
                                      duration: Duration(seconds: 30),
                                      content: Text(
                                        //'Password Reset Email has been sent !',
                                        'تم إرسال إلى البريد الإلكتروني الخاص بك لإعادة تعيين كلمة المرور',
                                        style: TextStyle(fontSize: 18.0),
                                          textAlign: TextAlign.right,
                                      ),
                                    ),
                                  );

                                }on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print("No user found for that email");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.orangeAccent,
                                        duration: Duration(seconds: 1000),
                                        //padding: EdgeInsets.only(right: 30.0),
                                        action: SnackBarAction(
                                            label: 'حسنًا',
                                            textColor: Colors.white,
                                            onPressed: () {
                                            }),
                                        content: Text(
                                          "لم يتم العثور على مستخدم لهذا البريد الإلكتروني",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                            textAlign: TextAlign.right,
                                        ),),);
                                  }
                                } catch (e) {
                                  print(e); }

                                setState(() {
                                  _isProcessing = false;
                                });
                              }



                              },

                              child: Padding(padding: EdgeInsets.only(top: 16.0, bottom: 16.0), child: Text('أرسال ايميل',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2,
                                ),),
                        ),
                      ),
                    ),
                    ),
                   ),
                    ),


                 ],
                )

          )

    ),
 ),

);





}
}