
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plantory/data/plant.dart';

class Person{

  Person({this.uid,this.email, this.name, this.image, this.permission, this.plants});

  String? uid;
  String? email;
  String? name;
  String? image;
  String? permission;
  List<Plant?>? plants;
  /*
  Person.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json['email'],
        name = json['name'],
        image = json["image"],
        permission = json["permission"],
        plants = plantsFromJson(json["permission"]);

   */

  Person.fromJson(Map<String, dynamic> json){
    uid = json["uid"];
    email = json['email'];
    name = json['name'];
    image = json["image"];
    permission = json["permission"];
    plants = plantsFromJson(json["plants"]);
  }

  Map<String, dynamic> toJson() =>
      {
        'uid' : uid,
        'email': email,
        'name': name,
        'image' : image,
        'permission' : permission,
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
