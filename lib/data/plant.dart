

enum Cycles{id,type,cycle,startDate,init}
enum CycleType{watering, repotting}

class Plant{

  Plant({this.id, this.image, this.pinned, this.name, this.type, this.date, this.note, this.cycles});

  final int? id;
  final String? image;
  final bool? pinned;
  final String? name;
  final String? type;
  final String? date;
  final String? note;
  final List? cycles;

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

