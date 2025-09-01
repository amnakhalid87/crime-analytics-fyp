import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<({User user, bool isAdmin})> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      bool isAdmin = await _checkIfAdmin(userCredential.user!.uid);

      return (user: userCredential.user!, isAdmin: isAdmin);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'isAdmin': false,
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<bool> _checkIfAdmin(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      print("User doc exists: ${userDoc.exists}");
      if (userDoc.exists) {
        print("User data: ${userDoc.data()}");
        print("isAdmin value: ${userDoc.get('isAdmin')}");
      }

      return userDoc.exists && userDoc.get('isAdmin') == true;
    } catch (e) {
      print("Error checking admin: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
