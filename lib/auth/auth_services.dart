// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart' as app_user;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<app_user.User?> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final app_user.User newUser = app_user.User(
          uid: result.user!.uid,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          cvs: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(result.user!.uid).set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<app_user.User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final doc = await _firestore.collection('users').doc(result.user!.uid).get();
        return app_user.User.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}


