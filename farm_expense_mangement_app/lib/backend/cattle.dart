
class Cattle {
  final String uid;
  final String sex;
  final int age;
  final String breed;
  final int weight;
  final int  lactationCycle;

  Cattle(this.uid,this.sex,this.age,this.breed,this.lactationCycle,this.weight);

  Cattle.fromJson(Map<String,dynamic> jsn)
  :uid = jsn['uid'] as String,
  sex = jsn['sex'] as String,
  age = jsn['age'] as int,
  breed = jsn['breed'] as String,
  weight = jsn['weight'] as int,
  lactationCycle = jsn['lactationCycle'] as int;

  Map<String,dynamic> toJson() =>
      {
        'uid':uid,
        'sex':sex,
        'age':age,
        'breed':breed,
        'weight':weight,
        'lactationCycle':lactationCycle,
      };


}