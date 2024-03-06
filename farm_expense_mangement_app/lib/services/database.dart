
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cattle.dart';
import '../models/user.dart';

//TODO:for User database access
class DatabaseServicesForUser{
  final String uid;
  DatabaseServicesForUser(this.uid);

  Future<void> infoToServer(String uid,FarmUser userInfo) async{

    FirebaseFirestore db = FirebaseFirestore.instance;
    return await db.collection('User').doc(uid).set(userInfo.toFireStore());
  }

  Future<DocumentSnapshot<Map<String,dynamic>>> infoFromServer(String uid) async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db.collection('User').doc(uid).get();
  }


}



//TODO: for Cattle database access
class DatabaseServicesForCattle{
  final String uid;
  DatabaseServicesForCattle(this.uid);


  Future<void> infoToServerSingleCattle(Cattle cattle) async{

    FirebaseFirestore db = FirebaseFirestore.instance;
    return await db.collection('User').doc(uid).collection('Cattle').doc(cattle.rfid).set(cattle.toFireStore());
  }


  Future<QuerySnapshot<Map<String, dynamic>>> infoFromServerAllCattle(String uid) async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db.collection('User').doc(uid).collection('Cattle').get();
  }


  Future<DocumentSnapshot<Map<String,dynamic>>> infoFromServer(String uid,String rfid) async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db.collection('User').doc(uid).collection('Cattle').doc(rfid).get();
  }



}