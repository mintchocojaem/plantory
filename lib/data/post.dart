
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

class Post{

  Post({this.uid, this.id, this.date, this.title, this.content, this.userPermission,
    this.like, this.comments, this.image, this.userName, this.theNumberOfComments});

  String? uid;
  String? userName;
  String? userPermission;
  String? id;
  String? image;
  String? date;
  String? title;
  String? content;
  List? like;
  List<Comment?>? comments;
  int? theNumberOfComments;

  Post.fromJson(Map<String, dynamic> json) {
    userName = json["userName"];
    userPermission = json["userPermission"];
    uid = json["uid"];
    id = json["id"];
    image = json["image"];
    date = json["date"];
    title = json["title"];
    content = json["content"];
    like = json["like"];
    comments = commentsFromJson(json["comments"]);
    theNumberOfComments = json["theNumberOfComments"];
  }

  Map<String, dynamic> toJson() {
    return  {
      'uid' : uid,
      'userName' : userName,
      'id' : id,
      'userPermission' : userPermission,
      'image' : image,
      'date' : date,
      'title' : title,
      'content' : content,
      'like': (like != null && like!.isNotEmpty) ?  like : [],
      'comments': (comments != null && comments!.isNotEmpty) ?  commentsToJson(comments!): [],
      'theNumberOfComments' : theNumberOfComments
    };
  }

  List commentsToJson(List<Comment?> comments){
    List result = List.empty(growable: true);
    for(int i = 0; i < comments.length; i++){
      result.add(comments[i]!.toJson());
    }
    return result;
  }

  List<Comment?> commentsFromJson(List comments){
    List<Comment?> result = List.empty(growable: true);
    for(int i = 0; i < comments.length; i++){
      result.add(Comment.fromJson(comments[i]));
    }
    return result;
  }

}

String getRandomString(int length) {
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
