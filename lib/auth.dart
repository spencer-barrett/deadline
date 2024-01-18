import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

//Sign a user in
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

//Create new user
  Future<void> createUser({
    required String uid,
    required String email,
    required String username,
  }) async {
    print('reach');
    await db.collection("users").doc(uid).set({
      'Points': 0,
      'Name': username,
      'Email': email,
    });
  }

//Helper for createUser
  Future<void> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print("reg");
    createUser(uid: result.user!.uid, email: email, username: username);
  }

//Sign user out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
