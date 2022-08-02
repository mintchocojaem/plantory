

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

}

int generateID(List<Plant> plantList){

  int id = 0;
  List<int> idList = List.empty(growable: true);

  for(Plant i in plantList){
    idList.add(i.id!);
  }
  for(int j = 0; j < 128; j++){
    if(!idList.contains(j)){
      id = j;
      break;
    }
  }

  return id;
}

int generateCycleID(List<Plant> plantList){

  int id = 0;
  List<int> idList = List.empty(growable: true);

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

  return id;
}
