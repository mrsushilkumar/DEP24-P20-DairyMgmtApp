

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/models/transaction.dart';

class DatabaseForSale {
  String uid;
  DatabaseForSale({required this.uid});

  Future<QuerySnapshot<Map<String,dynamic>>> infoFromServerAllTransaction() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('sale')
        .orderBy('saleOnMonth',descending: true)
        .get();
  }

  Future<void> infoToServerFeed(Sale sale) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('sale')
        .doc("M${sale.saleOnMonth.month}Y${sale.saleOnMonth.year}")
        .set(sale.toFireStore());
  }

}