import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/mobule/Userc.dart';

class AuthMethods{
  Userc _userFromFirebaseUser(User user){
    return Userc(userId: user.uid);
  }
  final FirebaseAuth _auth =FirebaseAuth.instance;
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
        User? user=result.user;
       return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString())  ;
    }
  }

  Future signUpWIthEmailAndPassword(String email,String password) async{
    try{
      final UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
       User? user =result.user;
       return _userFromFirebaseUser(user!);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.toString());
    }
  }
  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }
}