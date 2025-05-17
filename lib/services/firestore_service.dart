import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static Future<DocumentReference> addCost({
    required String name,
    required double amount,
    String? note,
    String? category,
    int? iconCode,
  }) async {
    try {
      return await _instance.collection('costs').add({
        'name': name,
        'amount': amount,
        'note': note,
        'category': category,
        'categoryIcon': iconCode,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });
    } catch (e) {
      throw 'Firestore error: ${e.toString()}';
    }
  }
}