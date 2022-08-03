
enum Cycles{id,type,cycle,startDate,init}
enum CycleType{watering, repotting}

class Plant{

  Plant({
    this.id,
    this.image,
    this.pinned,
    this.name,
    this.type,
    this.date,
    this.note,
    this.cycles,
    this.timelines
  });

  int? id;
  String? image;
  bool? pinned;
  String? name;
  String? type;
  String? date;
  String? note;
  List? cycles;
  List? timelines;

  Plant.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        image = json['image'],
        pinned = json['pinned'] == "true" ? true : false,
        name = json["name"],
        type = json["type"],
        date = json["date"],
        note = json["note"],
        cycles = json["cycles"],
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
        'cycles' : cycles,
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
      for(Map j in i.cycles!){
        idList.add(j[Cycles.id.name]);
      }
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
