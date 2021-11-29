import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FireAuth {
  // For registering a new user
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;



      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': name,
        'email': email,
        'userUid':user.uid,
      });

      await user.reload();
      user = auth.currentUser;


    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;



      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<User?> UpdateName({
    required String name,
      }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
    final user = FirebaseAuth.instance.currentUser;
    await user!.updateDisplayName(name);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'name': name,});
    } catch (e) {}

    User? refreshedUser = auth.currentUser;

    return refreshedUser;
    }



  static Future<User?> UpdatePassword({
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.updatePassword(password);

    } catch (e) {}

    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }



  static Future<User?> ResetPassword({
    required String email,
  }) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
