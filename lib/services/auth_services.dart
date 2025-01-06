// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart' as app_user;

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   Future<app_user.User?> getCurrentUser() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final doc = await _firestore.collection('users').doc(user.uid).get();
//       return app_user.User.fromFirestore(doc);
//     }
//     return null;
//   }

//   Future<app_user.User?> signIn(String email, String password) async {
//     try {
//       final credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password
//       );
//       if (credential.user != null) {
//         final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
//         return app_user.User.fromFirestore(doc);
//       }
//     } catch (e) {
//       throw Exception('Failed to sign in: ${e.toString()}');
//     }
//     return null;
//   }

//   Future<app_user.User?> register(String email, String password, String fullName, String phone) async {
//     try {
//       final credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password
//       );
      
//       if (credential.user != null) {
//         final newUser = app_user.User(
//           uid: credential.user!.uid,
//           email: email,
//           fullName: fullName,
//           phoneNumber: phone,
//           cvs: [],
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now()
//         );

//         await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toMap());
//         return newUser;
//       }
//     } catch (e) {
//       throw Exception('Failed to register: ${e.toString()}');
//     }
//     return null;
//   }

//   Future<void> signOut() => _auth.signOut();

//   Future<void> resetPassword(String email) => _auth.sendPasswordResetEmail(email: email);
// }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  Future<app_user.User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return app_user.User.fromFirestore(doc);
      }
    }
    return null;
  }

  // Login
  Future<app_user.User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
      if (credential.user != null) {
        final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
        if (doc.exists) {
          return app_user.User.fromFirestore(doc);
        }
      }
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
    return null;
  }

  // Register
  Future<app_user.User?> register(String email, String password, String fullName, String phone) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      
      if (credential.user != null) {
        final newUser = app_user.User(
          uid: credential.user!.uid,
          email: email,
          fullName: fullName,
          phoneNumber: phone,
          cvs: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()
        );

        await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      throw Exception('Failed to register: ${e.toString()}');
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send reset password email: ${e.toString()}');
    }
  }
}