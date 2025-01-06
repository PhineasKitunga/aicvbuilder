// storage_service.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/models.dart';
import '../models/models.dart' as app_user;



// class StorageService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> saveCV(String userId, CV cv) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('cvs')
//           .doc(cv.id)
//           .set(cv.toMap());
//     } catch (e) {
//       throw Exception('Failed to save CV: ${e.toString()}');
//     }
//   }

//   Future<List<CV>> getUserCVs(String userId) async {
//     try {
//       final snapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('cvs')
//           .get();

//       return snapshot.docs.map((doc) {
//         final data = doc.data();
//         data['id'] = doc.id;
//         return CV.fromMap(data);
//       }).toList();
//     } catch (e) {
//       throw Exception('Failed to fetch CVs: ${e.toString()}');
//     }
//   }

//   Future<String> uploadProfileImage(String userId, List<int> imageBytes) async {
//     try {
//       final ref = _storage.ref().child('profile_images/$userId.jpg');
//       await ref.putData(Uint8List.fromList(imageBytes));
//       return await ref.getDownloadURL();
//     } catch (e) {
//       throw Exception('Failed to upload image: ${e.toString()}');
//     }
//   }

//   Future<void> updateUserProfile(app_user.User user) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .update(user.toMap());
//     } catch (e) {
//       throw Exception('Failed to update profile: ${e.toString()}');
//     }
//   }

//   Future<void> deleteCV(String userId, String cvId) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('cvs')
//           .doc(cvId)
//           .delete();
//     } catch (e) {
//       throw Exception('Failed to delete CV: ${e.toString()}');
//     }
//   }
// }


class StorageService extends GetxService {  // Extend GetxService
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StorageService> init() async {  // Add init method
    return this;
  }

  Future<void> saveCV(String userId, CV cv) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cvs')
          .doc(cv.id)
          .set(cv.toMap());
    } catch (e) {
      throw Exception('Failed to save CV: ${e.toString()}');
    }
  }

  Future<List<CV>> getUserCVs(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cvs')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CV.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch CVs: ${e.toString()}');
    }
  }

  Future<void> deleteCV(String userId, String cvId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cvs')
          .doc(cvId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete CV: ${e.toString()}');
    }
  }
}