//TODO: for Cattle database access
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/feed.dart';

class DatabaseServicesForCattle {
  final String uid;
  DatabaseServicesForCattle(this.uid);

  Future<void> infoToServerFeed(Feed cattle) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(cattle.itemName)
        .set(cattle.toFireStore());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> infoFromServer(
      String itemName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(itemName)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> infoFromServerAllCattle(
      String uid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .orderBy('itemName')
        .get();
  }

  Future<void> deleteCattle(String itemName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(itemName)
        .delete();
  }

}
