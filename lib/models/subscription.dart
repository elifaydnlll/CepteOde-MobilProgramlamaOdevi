import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Subscription {
  String id;
  String name;
  String category; // 'Video', 'Music', 'Utility', 'Social', 'Gaming'
  double price;
  DateTime nextRenewalDate;
  Color color;

  Subscription({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.nextRenewalDate,
    required this.color,
  });

  factory Subscription.fromMap(String id, Map<String, dynamic> map) {
    return Subscription(
      id: id,
      name: map['name'] ?? 'Unknown',
      category: map['category'] ?? 'Utility',
      price: (map['price'] ?? 0).toDouble(),
      nextRenewalDate: (map['nextRenewalDate'] as Timestamp).toDate(),
      color: Color(map['colorValue'] ?? 0xFF000000),
    );
  }
}

// Global list REMOVED - we will fetch from Firebase
List<Subscription> mockSubscriptions = [];
