import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/screens_home/edit_name.dart';
import 'package:log_in/screens/screens_home/edit_password.dart';
import 'package:log_in/screens/screens_home/home_screen.dart';
import 'package:log_in/utils/fire_auth.dart';
import 'package:log_in/utils/background_image_widget.dart';



class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;



  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage("assets/Colorized Register&Login v2 – 20.png"),

    child:Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      title: Text('الملف الشخصي',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0390C3), letterSpacing: 2,
      ),),
    elevation: 0,
    leading: BackButton(
    color: Color(0xFF535353)
    ),
    backgroundColor: Color(0xFFF5F8FA),
      centerTitle: true,
      actions: [
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            textTheme: TextTheme().apply(bodyColor: Colors.white),
          ),
          child: PopupMenuButton<int>(
            offset: Offset(0, 50),
            color:Color(0xFF0390C3),
            onSelected: (item) => onSelected(context, item,_currentUser),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.logout ,color: Colors.red,),),
                    const SizedBox(width: 8),
                    Container(
                      alignment: Alignment.centerRight,
                  child:Text('تسجيل خروج'),
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],

    ),

    body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            InkWell(
              child: Card(
                elevation: 3,
             shadowColor: Colors.blueGrey,
            color: Colors.white,
             margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),

              child: ListTile(
                 leading: Icon(
               Icons.person_rounded,
               color: Color(0xFF0390C3),),

               title :Text(
              ' ${_currentUser.displayName}',
              style: TextStyle(fontSize: 18, color: Colors.black,)
            ),

                trailing: Wrap(
                    spacing: 0,
                    children: <Widget>[
                      IconButton(
                        alignment: Alignment.centerLeft,

                        onPressed: () =>
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditName(user:_currentUser,)
                              ),
                            ),
                        icon: Icon(Icons.edit,size: 24,), color: Colors.black,),
                    ]
                ),

              ),
            ),
            ),



              InkWell(
               child: Card(
                 elevation: 3,
                 shadowColor: Colors.blueGrey,
                 color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
               child: ListTile(
               leading: Icon(
                Icons.email,
                 color: Color(0xFF0390C3),),

                title :Text(
                  ' ${_currentUser.email}',
               style: TextStyle(fontSize: 18, color: Colors.black,)),
                  ),
                  ),
               ),


            InkWell(
              child: Card(
                elevation: 3,
                shadowColor: Colors.blueGrey,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.lock,
                    color: Color(0xFF0390C3),),

                  title :Text(
                      ' ********* ',
                      style: TextStyle(fontSize: 20, color: Colors.black,)),



                trailing: Wrap(
                  spacing: 0,

                  children: <Widget>[

                IconButton(
                alignment: Alignment.centerLeft,

                  onPressed: () =>
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditPassword(user:_currentUser,)
                        ),
                      ),
                  icon: Icon(Icons.edit,size: 25,), color: Colors.black,),
                ]
                ),
              ),
            ),
            ),



            SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? Text(
              'تم التحقق من البريد الإلكتروني',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.green),
            )
                : Text(
              'لم يتم التحقق من البريد الإلكتروني',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.red),
            ),
            SizedBox(height: 16.0),
            _isSendingVerification
                ? CircularProgressIndicator()
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF0390C3)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),),


                  onPressed: () async {
                    setState(() {
                      _isSendingVerification = true;
                    });
                    await _currentUser.sendEmailVerification();
                    setState(() {
                      _isSendingVerification = false;
                    });
                  },
                  child: Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0 ,left: 16.0,right: 16.0), child: Text('التحقق من البريد الإلكتروني',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2,
                  ),),
                  ),


                ),
                SizedBox(width: 1.0),
                Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0 ,left: 1),
                child: IconButton(
                  icon: Icon(Icons.refresh,
                    color: Color(0xFF0390C3),),

                  onPressed: () async {
                    User? user = await FireAuth.refreshUser(_currentUser);

                    if (user != null) {
                      setState(() {
                        _currentUser = user;
                      });
                    }
                  },
                ),
                ),

              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  void onSelected(BuildContext context, int item,User user) {
    switch (item) {
      case 0:
        _signOut();
    }}

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
    );
  }
}
