import 'package:plantory/data/plant.dart';

class Person{

  Person({this.uid,this.email, this.userName, this.userPermission, this.plants});

  String? uid;
  String? email;
  String? userName;
  String? userPermission;
  List<Plant?>? plants;

  Person.fromJson(Map<String, dynamic> json){
    uid = json["uid"];
    email = json['email'];
    userName = json['name'];
    userPermission = json["userPermission"];
    plants = plantsFromJson(json["plants"]);
  }

  Map<String, dynamic> toJson() =>
      {
        'uid' : uid,
        'email': email,
        'userName': userName,
        'userPermission' : userPermission,
        'plants' : (plants != null && plants!.isNotEmpty) ? plantsToJson(plants!) : null
      };

  List plantsToJson(List<Plant?> plants){
    List result = List.empty(growable: true);
    for(int i = 0; i < plants.length; i++){
      result.add(plants[i]!.toJson());
    }
    return result;
  }

  List<Plant> plantsFromJson(List plants){
    List<Plant> result = List.empty(growable: true);
    for(int i = 0; i < plants.length; i++){
      result.add(Plant.fromJson(plants[i]));
    }
    return result;
  }

}
