import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:plantory/data/comment.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../../data/person.dart';
import '../../data/post.dart';

class PostDetailPage extends StatefulWidget{

  const PostDetailPage({Key? key, required this.uid, required this.id, required this.person}) : super(key: key);

  final String uid;
  final String id;
  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PostDetailPage();
  }

}

class _PostDetailPage extends State<PostDetailPage>{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> postData = {};

  String postUserName = " User";
  List<String> commentUserNames = List.empty(growable: true);
  List<List<String>> subCommentUserNames = List.empty(growable: true);

  TextEditingController commentController = TextEditingController();

  String commentHintText = "댓글을 입력하세요.";

  FocusNode focusNode = FocusNode();

  int? commentIndex;

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Color(0xffEEF1F1),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black54,),
              onPressed: () { Navigator.pop(context); },
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xffEEF1F1),
            title: const Text(
              "Post",
              style: TextStyle(color: primaryColor),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10, bottom: MediaQuery.of(context).size.height * 0.1),
                      child: Center(
                        child: FutureBuilder(
                            future: getPostData(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if(snapshot.hasData == false){
                                return CircularProgressIndicator();
                              }else if(snapshot.hasError){
                                return CircularProgressIndicator();
                              }else{
                                return Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 12,left: 12,bottom: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                            title: Text(postUserName,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04)),
                                            subtitle: Text(snapshot.data.date,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),),
                                            leading: Container(
                                                width: MediaQuery.of(context).size.width * 0.1,
                                                height: MediaQuery.of(context).size.width * 0.1,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black54,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.1))
                                                ),
                                                child: Icon(Icons.person,size: MediaQuery.of(context).size.width * 0.06,),
                                            ),
                                            trailing:  Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: SizedBox(
                                                  height: MediaQuery.of(context).size.width * 0.06,
                                                  width: MediaQuery.of(context).size.width * 0.06,
                                                  child: IconButton(
                                                    padding: new EdgeInsets.all(0.0),
                                                    icon: new Icon(Icons.thumb_up,size: MediaQuery.of(context).size.width * 0.035,),
                                                    onPressed: () async{
                                                      if(!postData["like"].contains(widget.person.uid)){
                                                        postData["like"].add(widget.person.uid);
                                                        await firestore.collection('board').doc(widget.uid).update({
                                                          widget.id : postData
                                                        }).whenComplete(() => setState((){}));
                                                      }else{
                                                        postData["like"].remove(widget.person.uid);
                                                        await firestore.collection('board').doc(widget.uid).update({
                                                          widget.id : postData
                                                        }).whenComplete(() => setState((){}));
                                                      }
                                                    },
                                                    color: Colors.black87,
                                                  )
                                              ),
                                            ),
                                          ),
                                          Text(snapshot.data.content,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8,left: 8, right: 8),
                                                child: Icon(Icons.thumb_up,size: MediaQuery.of(context).size.width * 0.035,),
                                              ),
                                              Text(snapshot.data.like.length.toString(),style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035)),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8,left: 8, right: 8),
                                                child: Icon(Icons.comment_rounded,size: MediaQuery.of(context).size.width * 0.035,),
                                              ),
                                              Text((commentUserNames.length+subCommentUserNames.length).toString(),style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.comments.length,
                                      itemBuilder: (context, index){
                                        return Container(
                                          margin: EdgeInsets.only(right: 12,left: 12,bottom: 12),
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ListTile(
                                                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                        dense: true,
                                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                        title: Text(commentUserNames[index] ,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                        leading: Container(
                                                            width: MediaQuery.of(context).size.width * 0.08,
                                                            height: MediaQuery.of(context).size.width * 0.08,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors.black54,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.08))
                                                            ),
                                                            child: Icon(Icons.person,size: MediaQuery.of(context).size.width * 0.05,)
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 8,
                                                        child: SizedBox(
                                                            height: MediaQuery.of(context).size.width * 0.06,
                                                            width: MediaQuery.of(context).size.width * 0.06,
                                                            child: IconButton(
                                                              padding: new EdgeInsets.all(0.0),
                                                              icon: new Icon(Icons.comment_rounded,size: MediaQuery.of(context).size.width * 0.035,),
                                                              onPressed: (){
                                                                showDialog(barrierColor: Colors.black54, context: context, builder: (context) {
                                                                  return CupertinoAlertDialog(
                                                                    content: Padding(
                                                                      padding: const EdgeInsets.only(top: 8),
                                                                      child: Text("대댓글을 작성하시겠습니까?"),
                                                                    ),
                                                                    actions: [
                                                                      CupertinoDialogAction(isDefaultAction: false, child: Text("취소"), onPressed: () {
                                                                        Get.back();
                                                                      }),
                                                                      CupertinoDialogAction(isDefaultAction: false, child: const Text("확인"),
                                                                          onPressed: (){
                                                                            setState((){
                                                                              commentHintText = "대댓글을 입력하세요.";
                                                                              focusNode.requestFocus();
                                                                              commentIndex = index;
                                                                              Get.back();
                                                                            });
                                                                          }
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                              },
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4,bottom: 4),
                                                    child: Text(snapshot.data.comments[index].content,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                  ),
                                                ],
                                              ),
                                              ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: snapshot.data.comments[index].subComments.length,
                                                itemBuilder: (context, position) {
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsets.only(top: 24),
                                                          child: Icon(Icons.subdirectory_arrow_right_outlined,color: Colors.black45,)
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                          decoration: new BoxDecoration(
                                                              color: Color(0xffC9D9CF),
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),),
                                                          padding: EdgeInsets.only(right: 16,left: 16,top: 8,bottom: 8),
                                                          margin: EdgeInsets.only(left: 12, top: 12),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  ListTile(
                                                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                                    dense: true,
                                                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                                    title: Text(subCommentUserNames[index][position],style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                                    leading: Container(
                                                                        width: MediaQuery.of(context).size.width * 0.08,
                                                                        height: MediaQuery.of(context).size.width * 0.08,
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                              color: Colors.black54,
                                                                            ),
                                                                            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.08))
                                                                        ),
                                                                        child: Icon(Icons.person,size: MediaQuery.of(context).size.width * 0.05,)
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 4,bottom: 4),
                                                                child: Text(snapshot.data.comments[index].subComments[position].content,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                              ),
                                                              Text(snapshot.data.comments[index].subComments[position].date,style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035),)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        );
                                    })
                                  ],
                                );
                              }
                            }
                        ),
                      ),
                    )
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          color: Color(0xffC9D9CF),
                          padding:  EdgeInsets.all(16),
                          child: TextFormField(
                            focusNode: focusNode,
                            controller: commentController,
                            autocorrect: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffEEF1F1),
                              contentPadding: EdgeInsets.symmetric(vertical: -4.0,horizontal: 16),
                              hintText: commentHintText,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send_rounded),
                                color: primaryColor,
                                iconSize: 20.0,
                                onPressed: () async{
                                  if(commentIndex != null){
                                    postData["comments"][commentIndex]["subComments"].add(
                                        SubComment(
                                            uid: widget.person.uid,
                                            id: getRandomString(12),
                                            date: DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now()).toString(),
                                            content: commentController.text
                                        ).toJson()
                                    );
                                    await firestore.collection('board').doc(widget.uid).update({
                                      widget.id : postData
                                    }).whenComplete(() => setState((){
                                      commentIndex = null;
                                      commentHintText = "댓글을 입력하세요";
                                    }));

                                  }else{
                                    postData["comments"].add(
                                        Comment(
                                            uid: widget.person.uid,
                                            id: getRandomString(12),
                                            date: DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now()).toString(),
                                            subComments: [],
                                            content: commentController.text
                                        ).toJson()
                                    );
                                    await firestore.collection('board').doc(widget.uid).update({
                                      widget.id : postData
                                    }).whenComplete(() => setState((){
                                      commentIndex = null;
                                      commentHintText = "댓글을 입력하세요";
                                    }));
                                  }
                                  commentController.clear();
                                  focusNode.unfocus();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffEEF1F1), width: 1.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder:OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffEEF1F1), width: 1.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        )
                    )
                ),
              ],
            ),
          ),

        );
      }
    );

  }

  getPostData() async{
    List<String> tempCommentUserNames = List.empty(growable: true);
    List<List<String>> tempSubCommentUserNames = List.empty(growable: true);

    postData = await firestore.collection('board').doc(widget.uid).get().then((value) => value.data()![widget.id]);

    Post post = Post.fromJson(postData);

    var usersCollection = firestore.collection('users');
    postUserName = await usersCollection.doc(widget.uid).get().then((value) =>  value["name"]);

    if(post.comments!.isNotEmpty){
      for(Comment? i in post.comments!){
        String name = await usersCollection.doc(i!.uid).get().then((value) =>  value["name"]);
        tempCommentUserNames.add(name);
        if(i.subComments!.isNotEmpty){
          List<String> temp = List.empty(growable: true);
          for(SubComment? j in i.subComments!){
            String name = await usersCollection.doc(j!.uid).get().then((value) =>  value["name"]);
            temp.add(name);
          }
          tempSubCommentUserNames.add(temp);
        }
      }
    }
    commentUserNames = tempCommentUserNames;
    subCommentUserNames = tempSubCommentUserNames;

    return post;
  }

}
