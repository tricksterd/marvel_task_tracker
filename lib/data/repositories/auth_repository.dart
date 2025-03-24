import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  User? get getCurrentUser => _auth.currentUser;

  Future<User?> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<User?> signUp(
    String username,
    String email,
    String password,
  ) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
