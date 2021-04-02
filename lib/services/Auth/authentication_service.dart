import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<String> signup(email, password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      return e.toString();
    }
    return "signin";
  }

  Future<String> signIn(email, password,username) async {
   
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user.user.updateProfile(displayName:username );
     return "sigin in";
    } catch (e) {
      return e.toString();
    }
    
  }

  Future<String> signout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      return e.toString();
    }
    return "signout";
  }
}
