

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/models/milk.dart';

class DatabaseForMilk {
  final String uid;
  DatabaseForMilk(this.uid);

  Future<QuerySnapshot<Map<String,dynamic>>> infoFromServerAllMilk() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return await db
        .collection('User')
        .doc(uid)
        .collection('milk')
        .orderBy('dateOfMilk')
        .get();
  }

  Future<void> infoToServerFeed(Milk milk) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('milk')
        .doc(milk.rfid)
        .set(milk.toFireStore());
  }

}