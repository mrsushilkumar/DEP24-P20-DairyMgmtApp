import 'package:cloud_firestore/cloud_firestore.dart';

class CattleHistory {
  final String name;
  final DateTime date;
  CattleHistory({required this.name, required this.date});

  factory CattleHistory.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return CattleHistory(name: data?['name'], date: data?['name']);
        // dateOfBirth: data?['dateOfBirth']

  }

  Map<String, dynamic> toFireStore() {
    return {'name': name, 'date': date};
  }
}
