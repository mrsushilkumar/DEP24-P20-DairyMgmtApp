import 'package:cloud_firestore/cloud_firestore.dart';

class Milk {
  int morning;
  int evening;
  DateTime dateOfMilk;
  String rfid;
  Milk({required this.rfid,required this.morning, required this.evening, required this.dateOfMilk});


  factory Milk.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    final data = snapshot.data();
    return Milk(morning: data?['morning'], evening: data?['evening'], dateOfMilk: data?['dateOfMilk'],rfid: data?['rfid']);
  }

  Map<String,dynamic> toFireStore() {
    return {'morning': morning,'evening':evening,'dateOfMilk':dateOfMilk,'rfid':rfid};
  }

}
