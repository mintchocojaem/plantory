
class Comment{

  Comment({this.uid, this.id, this.date, this.content,this.subComments});

  String? uid;
  String? id;
  String? date;
  String? content;
  List<SubComment?>? subComments;

  Map<String, dynamic> toJson() =>
      {
        'uid': uid,
        'id': id,
        'date': date,
        'content': content,
        'subComments': (subComments != null && subComments!.isNotEmpty) ?  commentsFromJson(subComments!): []
      };

  Comment.fromJson(Map<String, dynamic> json){
    uid = json["uid"];
    id = json["id"];
    date = json["date"];
    content = json["content"];
    subComments = commentsFromJson(json["subComments"]);
  }

  List<SubComment?> commentsFromJson(List comments){
    List<SubComment?> result = List.empty(growable: true);
    for(int i = 0; i < comments.length; i++){
      result.add(SubComment.fromJson(comments[i]));
    }
    return result;
  }

  List commentsToJson(List<Comment?> comments){
    List result = List.empty(growable: true);
    for(int i = 0; i < comments.length; i++){
      result.add(comments[i]!.toJson());
    }
    return result;
  }

}

class SubComment{

  SubComment({this.uid, this.id, this.date, this.content});

  String? uid;
  String? id;
  String? date;
  String? content;

  Map<String, dynamic> toJson() =>
      {
        'uid': uid,
        'id': id,
        'date': date,
        'content': content,
      };

  SubComment.fromJson(Map<String, dynamic> json){
    uid = json["uid"];
    id = json["id"];
    date = json["date"];
    content = json["content"];
  }

}
