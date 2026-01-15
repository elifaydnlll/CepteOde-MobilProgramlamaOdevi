import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subscription.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get Collection Reference for current user
  CollectionReference get _subsCollection {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return _db.collection('users').doc(user.uid).collection('subscriptions');
  }

  // Add Subscription
  Future<void> addSubscription(Subscription subscription) async {
    await _subsCollection.add({
      'name': subscription.name,
      'category': subscription.category,
      'price': subscription.price,
      'nextRenewalDate': Timestamp.fromDate(subscription.nextRenewalDate),
      'colorValue': subscription.color.toARGB32(), // storing int
    });
  }

  // Update Subscription
  Future<void> updateSubscription(Subscription subscription) async {
    await _subsCollection.doc(subscription.id).update({
      'name': subscription.name,
      'category': subscription.category,
      'price': subscription.price,
      'nextRenewalDate': Timestamp.fromDate(subscription.nextRenewalDate),
      'colorValue': subscription.color.toARGB32(),
    });
  }

  // Delete Subscription
  Future<void> deleteSubscription(String id) async {
    await _subsCollection.doc(id).delete();
  }

  // Get Subscriptions Stream
  Stream<List<Subscription>> get subscriptions {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('subscriptions')
        .orderBy('nextRenewalDate')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Subscription.fromMap(doc.id, data);
          }).toList();
        });
  }
}
