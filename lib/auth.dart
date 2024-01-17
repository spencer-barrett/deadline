import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUser({
    required String uid,
    required String email,
    required String username,
  }) async {
    print('reach');
    await db.collection("users").doc(uid).set({
      'Name': username,
      'Email': email,
    });
  }

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

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
