

import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  String? itemType;
  String itemName;
  int quantity;
  String? category;
  DateTime? expiryDate;
  int? requiredQuantity;
  int? month;
  int? year;


  Feed({
     this.itemType,
    required this.itemName,
    required this.quantity,
    this.category,
    this.expiryDate,
    this.requiredQuantity,
    this.month,
    this.year,

  });

  Map<String, dynamic> toFireStore() {
    return {
      'itemType': itemType,
      'itemName': itemName,
      'quantity': quantity,
      'category': category,
      'expiryDate': Timestamp.fromDate(expiryDate!),
      'requiredQuantity': requiredQuantity,
      'month': month,
      'year': year,

    };
  }

  factory Feed.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final json = snapshot.data();
    return Feed(
      itemType: json?['itemType'],
      itemName: json?['itemName'],
      quantity: json?['quantity'],
      category: json?['category'],
      expiryDate: (json?['expiryDate'] != null) ? json!['expiryDate'].toDate() : null,
      requiredQuantity: json?['requiredQuantity'],
      month: json?['month'],
      year: json?['year'],

    );
  }
}
