
enum Cycles{id,type,cycle,startDate,initDate}

class Plant{

  Plant({
    this.id,
    this.image,
    this.pinned,
    this.name,
    this.type,
    this.date,
    this.note,
    this.watering,
    this.timelines
  });

  int? id;
  String? image;
  bool? pinned;
  String? name;
  String? type;
  String? date;
  String? note;
  Map? watering;
  List? timelines;

  Plant.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        image = json['image'],
        pinned = json['pinned'],
        name = json["name"],
        type = json["type"],
        date = json["date"],
        note = json["note"],
        watering = json["watering"],
        timelines = json["timelines"];

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'image': image,
        'pinned': pinned,
        'name' : name,
        'type' : type,
        'date' : date,
        'note' : note,
        'watering' : watering,
        'timelines' : timelines,
      };

}

int generateID(List plantList){

  int id = 0;
  List<int> idList = List.empty(growable: true);
  if(plantList.isNotEmpty){
    for(Plant i in plantList){
      idList.add(i.id!);
    }
    for(int j = 0; j < 128; j++){
      if(!idList.contains(j)){
        id = j;
        break;
      }
    }
  }

  return id;
}

int generateCycleID(List plantList){

  int id = 0;
  List<int> idList = List.empty(growable: true);
  if(plantList.isNotEmpty){
    for(Plant i in plantList){
      idList.add(i.watering![Cycles.id.name]);
    }
    for(int j = 0; j < 128; j++){
      if(!idList.contains(j)){
        id = j;
        break;
      }
    }
  }

  return id;
}
