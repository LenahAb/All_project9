import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_home/sign_up.dart';
import 'package:log_in/utils/background_image_widget.dart';

import 'log_in.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage("assets/Colorized Splash v2 – 2.png"),

      child:Scaffold(
        backgroundColor: Colors.transparent,

         body:Column(
           children: [
             Center(child: Padding(padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 450.0,bottom: 0.0,),

               child: Container(width: double.maxFinite,


                 child: ElevatedButton(
                   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF0390C3)),
                     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),),

                   onPressed: () {Navigator.of(context).push(
                     MaterialPageRoute(
                       builder: (context) => LogIn(),
                     ),
                   );},

                   child: Padding(padding: EdgeInsets.only(top: 16.0, bottom: 16.0), child: Text('تسجيل الدخول',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2,
                     ),),
                   ),
                 ),
               ),
             ),

             ),
          Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [


                TextButton(
                 child: Text('  أنشئ الان',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueAccent, letterSpacing: 2,),),
                 onPressed: () {Navigator.of(context).push(
                   MaterialPageRoute(
                  builder: (context) => SingUp(),
                ),);},
                ),
                 Text(' لاتملك حساباً ؟',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2,),),
                     ],
                     ),
           ],
          )




    ),
    );



  }



}