import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  static Future<void> addChecklistItem(Map<String, dynamic> data) async {
    await _firestore.collection('checklistItems').add(data);
  }

  static Stream<QuerySnapshot> getChecklistItems() {
    return _firestore.collection('checklistItems')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}