

import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  double animalSale;
  double milkSale;
  double byProductSale;
  List<CustomCategory>? newCategory;
  DateTime saleOnMonth;

  Sale({required this.animalSale,required this.milkSale,required this.byProductSale,required this.saleOnMonth,this.newCategory});

  factory Sale.fromFireStore(
      DocumentSnapshot<Map<String,dynamic>> snapshot,
      SnapshotOptions? options
      ){
    final data = snapshot.data();
    return Sale(
        animalSale: data?['animalSale'],
        milkSale: data?['milkSale'],
        byProductSale: data?['byProductSale'],
        saleOnMonth: data?['saleOnMonth']
    );
  }

  Map<String,dynamic> toFireStore() {
    return {
      'animalSale': animalSale,
      'milkSale':milkSale,
      'byProductSale':byProductSale,
      'saleOnMonth': saleOnMonth
    };
  }

}


class Expanse {
  double animalExpanse;
  double waterExpanse;
  double electricityExpanse;
  double feedExpanse;

  Expanse({required this.animalExpanse,required this.electricityExpanse,required this.feedExpanse,required this.waterExpanse});


  factory Expanse.fromFireStore(
      DocumentSnapshot<Map<String,dynamic>> snapshot,
      SnapshotOptions? options
      ){
    final data = snapshot.data();
    return Expanse(
        animalExpanse: data?['animalExpanse'],
        electricityExpanse: data?['electricityExpanse'],
        feedExpanse: data?['feedExpanse'],
        waterExpanse: data?['waterExpanse']
    );
  }

  Map<String,dynamic> toFireStore() {
    return {
      'animalExpanse': animalExpanse,
      'electricityExpanse' : electricityExpanse,
      'feedExpanse': feedExpanse,
      'waterExpanse': waterExpanse
    };
  }

}


class CustomCategory {
  final String name;
  final double value;
  CustomCategory({required this.name,required this.value});
  factory CustomCategory.fromFireStore(
      DocumentSnapshot<Map<String,dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    final data = snapshot.data();
    return CustomCategory(
        name: data?['name'],
        value: data?['value']
    );
  }

  Map<String,dynamic> toFireStore() {
    return {
      'name': name,
      'value': value
    };
  }

}
