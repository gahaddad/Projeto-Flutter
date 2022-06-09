import 'package:firebase_auth/firebase_auth.dart';

class FireBaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> guestSignIn() async {
    await _auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
