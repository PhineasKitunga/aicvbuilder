// user.dart
import 'package:cloud_firestore/cloud_firestore.dart';


class User {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String? profileImage;
  final List<CV> cvs;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.profileImage,
    required this.cvs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'],
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      profileImage: data['profileImage'],
      cvs: (data['cvs'] as List).map((cv) => CV.fromMap(cv)).toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'cvs': cvs.map((cv) => cv.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

// cv.dart
class CV {
  String id;
  String title;
  List<Education> education;
  List<Experience> experience;
  List<String> skills;
  List<String> languages;
  String description;
  List<String> extractedKeywords;
  DateTime createdAt;
  DateTime updatedAt;

  CV({
    required this.id,
    required this.title,
    required this.education,
    required this.experience,
    required this.skills,
    required this.languages,
    required this.description,
    required this.extractedKeywords,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CV.fromMap(Map<String, dynamic> map) {
    return CV(
      id: map['id'],
      title: map['title'],
      education: (map['education'] as List).map((e) => Education.fromMap(e)).toList(),
      experience: (map['experience'] as List).map((e) => Experience.fromMap(e)).toList(),
      skills: List<String>.from(map['skills']),
      languages: List<String>.from(map['languages']),
      description: map['description'],
      extractedKeywords: List<String>.from(map['extractedKeywords']),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'education': education.map((e) => e.toMap()).toList(),
      'experience': experience.map((e) => e.toMap()).toList(),
      'skills': skills,
      'languages': languages,
      'description': description,
      'extractedKeywords': extractedKeywords,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class Education {
  String institution;
  String degree;
  String field;
  DateTime startDate;
  DateTime? endDate;
  double? gpa;
  List<String> achievements;

  Education({
    required this.institution,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    this.gpa,
    required this.achievements,
  });

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution'],
      degree: map['degree'],
      field: map['field'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
      gpa: map['gpa'],
      achievements: List<String>.from(map['achievements']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'degree': degree,
      'field': field,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'gpa': gpa,
      'achievements': achievements,
    };
  }
}

class Experience {
  String company;
  String position;
  String location;
  DateTime startDate;
  DateTime? endDate;
  bool isCurrentPosition;
  List<String> responsibilities;
  List<String> achievements;

  Experience({
    required this.company,
    required this.position,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.isCurrentPosition,
    required this.responsibilities,
    required this.achievements,
  });

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      company: map['company'],
      position: map['position'],
      location: map['location'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
      isCurrentPosition: map['isCurrentPosition'],
      responsibilities: List<String>.from(map['responsibilities']),
      achievements: List<String>.from(map['achievements']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'position': position,
      'location': location,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'isCurrentPosition': isCurrentPosition,
      'responsibilities': responsibilities,
      'achievements': achievements,
    };
  }
}

