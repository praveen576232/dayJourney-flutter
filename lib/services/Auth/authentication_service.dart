import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<String> signIn(email, password, username) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user.user.updateProfile(displayName: username);
      user.user.reload();
      return "sigin in";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await _firebaseAuth.signInWithCredential(credential);

      return "sign in";
    } catch (e) {
      print(e);
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
