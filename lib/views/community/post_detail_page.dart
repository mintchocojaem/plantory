import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:plantory/data/comment.dart';
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

  late Post post;

  late List postCommentsJson;

  TextEditingController commentController = TextEditingController();

  String commentHintText = "댓글을 입력하세요.";

  FocusNode focusNode = FocusNode();

  int? commentIndex;

  Color thumbColor = Color(0xffff8080);
  Color commentColor = Color(0xff66a3ff);

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
            actions: [
              widget.uid == widget.person.uid ? PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,color: Colors.black87,),
                onSelected: (value){
                  switch(value){
                    case "삭제" : showDialog(barrierColor: Colors.black54, context: context, builder: (context) {
                      return CupertinoAlertDialog(
                        content: const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text("게시글을 삭제하시겠습니까?"),
                        ),
                        actions: [
                          CupertinoDialogAction(isDefaultAction: false, child: Text("취소"), onPressed: () {
                            Get.back();
                          }),
                          CupertinoDialogAction(isDefaultAction: false, child: const Text("확인"),
                            onPressed: () async{
                              await firestore.collection('board').doc(widget.uid).update({
                                post.id! : FieldValue.delete()
                              }).whenComplete(() {
                                Get.back();
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      );
                    });
                    break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'삭제'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ) : Container(),
            ],
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
                                            title: Text(post.userName! + (post.userPermission! == "expert"? " / 🌱 전문가" : post.userPermission == "admin" ? " / ♠ 관리자" : ""),
                                                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04)),
                                            subtitle: Text(post.date!,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),),
                                            leading: post.userPermission == "expert" ? Container(
                                              width: MediaQuery.of(context).size.width * 0.1,
                                              height: MediaQuery.of(context).size.width * 0.1,
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.1))
                                              ),
                                              child: Icon(Icons.energy_savings_leaf,size: MediaQuery.of(context).size.width * 0.06,color:  Color(0xffEEF1F1),),
                                            ) : Container(
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
                                                    icon: new Icon(Icons.thumb_up,size: MediaQuery.of(context).size.width * 0.05,color: thumbColor,),
                                                    onPressed: () async{
                                                      if(!post.like!.contains(widget.person.uid)){
                                                        post.like!.add(widget.person.uid);
                                                        await firestore.collection('board').doc(widget.uid).update({
                                                          "${widget.id}.like" : post.like
                                                        }).whenComplete(() => setState((){}));
                                                      }else{
                                                        post.like!.remove(widget.person.uid);
                                                        await firestore.collection('board').doc(widget.uid).update({
                                                          "${widget.id}.like" : post.like
                                                        }).whenComplete(() => setState((){}));
                                                      }
                                                    },
                                                    color: Colors.black87,
                                                  )
                                              ),
                                            ),
                                          ),
                                          post.image != null ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: ClipRRect(
                                                  child: Image.memory(base64Decode(post.image!),gaplessPlayback: true,fit: BoxFit.cover,),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ) : Container(),
                                          Text(post.content!,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 4),
                                                  child: Icon(Icons.thumb_up,size: MediaQuery.of(context).size.width * 0.035,color: thumbColor,),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right : 8),
                                                  child: Text(post.like!.length.toString(),style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 4),
                                                  child: Icon(Icons.comment_rounded,size: MediaQuery.of(context).size.width * 0.035,color: commentColor,),
                                                ),
                                                Text(post.theNumberOfComments!.toString(),style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: post.comments!.length,
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
                                                        title: Text(post.comments![index]!.userName! + (post.comments![index]!.userPermission! == "expert"
                                                            ? " / 🌱 전문가" : post.comments![index]!.userPermission == "admin" ? " / ♠ 관리자" : ""),
                                                            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                        leading: post.comments![index]!.userPermission == "expert" ? Container(
                                                          width: MediaQuery.of(context).size.width * 0.08,
                                                          height: MediaQuery.of(context).size.width * 0.08,
                                                          decoration: BoxDecoration(
                                                              color: primaryColor,
                                                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.1))
                                                          ),
                                                          child: Icon(Icons.energy_savings_leaf,size: MediaQuery.of(context).size.width * 0.06,color:  Color(0xffEEF1F1),),
                                                        ) : Container(
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
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(context).size.width * 0.06,
                                                              width: MediaQuery.of(context).size.width * 0.06,
                                                              child: IconButton(
                                                                icon: Icon(Icons.comment_rounded,size: MediaQuery.of(context).size.width * 0.05,color: commentColor,),
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
                                                              ),
                                                            ),
                                                            post.comments![index]!.uid! == widget.person.uid
                                                                ? SizedBox(width: MediaQuery.of(context).size.width * 0.04,) : Container(),
                                                            post.comments![index]!.uid! == widget.person.uid ? SizedBox(
                                                              height: MediaQuery.of(context).size.width * 0.06,
                                                              width: MediaQuery.of(context).size.width * 0.06,
                                                              child: PopupMenuButton<String>(
                                                                icon: Icon(Icons.more_vert,color: Colors.black54,size: MediaQuery.of(context).size.width * 0.05),
                                                                onSelected: (value){
                                                                  switch(value){
                                                                    case "삭제" : showDialog(barrierColor: Colors.black54, context: context, builder: (context) {
                                                                      return CupertinoAlertDialog(
                                                                        content: const Padding(
                                                                          padding: EdgeInsets.only(top: 8),
                                                                          child: Text("댓글을 삭제하시겠습니까?"),
                                                                        ),
                                                                        actions: [
                                                                          CupertinoDialogAction(isDefaultAction: false, child: Text("취소"), onPressed: () {
                                                                            Get.back();
                                                                          }),
                                                                          CupertinoDialogAction(isDefaultAction: false, child: const Text("확인"),
                                                                            onPressed: () async{
                                                                            postCommentsJson.removeAt(index);
                                                                            await firestore.collection('board').doc(widget.uid).update({
                                                                              "${widget.id}.comments" : postCommentsJson,
                                                                              "${widget.id}.theNumberOfComments" : post.theNumberOfComments! -1
                                                                            }).whenComplete(() {
                                                                                setState((){
                                                                                  Get.back();
                                                                                  focusNode.unfocus();
                                                                                });
                                                                            });
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                                    break;
                                                                  }
                                                                },
                                                                itemBuilder: (BuildContext context) {
                                                                  return {'삭제'}.map((String choice) {
                                                                    return PopupMenuItem<String>(
                                                                      value: choice,
                                                                      child: Text(choice),
                                                                    );
                                                                  }).toList();
                                                                },
                                                              ),
                                                            ) : Container(),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Text(post.comments![index]!.content!,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                  ),
                                                  Text(post.comments![index]!.date!,style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035),)
                                                ],
                                              ),
                                              ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: post.comments![index]!.subComments!.length,
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
                                                                    title: Text("${post.comments![index]!.subComments![position]!.userName!}${post.comments![index]!.subComments![position]!.userPermission == "expert"
                                                                        ? " / 🌱 전문가" : post.comments![index]!.subComments![position]!.userPermission == "admin"
                                                                        ? " / ♠ 관리자" : ""}",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                                    leading: post.comments![index]!.subComments![position]!.userPermission == "expert" ? Container(
                                                                      width: MediaQuery.of(context).size.width * 0.08,
                                                                      height: MediaQuery.of(context).size.width * 0.08,
                                                                      decoration: BoxDecoration(
                                                                          color: primaryColor,
                                                                          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.1))
                                                                      ),
                                                                      child: Icon(Icons.energy_savings_leaf,size: MediaQuery.of(context).size.width * 0.06,color:  Color(0xffEEF1F1),),
                                                                    ) : Container(
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
                                                                    trailing: SizedBox(
                                                                      height: MediaQuery.of(context).size.width * 0.06,
                                                                      width: MediaQuery.of(context).size.width * 0.06,
                                                                      child: post.comments![index]!.subComments![position]!.uid! == widget.person.uid ? PopupMenuButton<String>(
                                                                        icon: Icon(Icons.more_vert,color: Colors.black54,size: MediaQuery.of(context).size.width * 0.05),
                                                                        onSelected: (value){
                                                                          switch(value){
                                                                            case "삭제" : showDialog(barrierColor: Colors.black54, context: context, builder: (context) {
                                                                              return CupertinoAlertDialog(
                                                                                content: const Padding(
                                                                                  padding: EdgeInsets.only(top: 8),
                                                                                  child: Text("대댓글을 삭제하시겠습니까?"),
                                                                                ),
                                                                                actions: [
                                                                                  CupertinoDialogAction(isDefaultAction: false, child: Text("취소"), onPressed: () {
                                                                                    Get.back();
                                                                                  }),
                                                                                  CupertinoDialogAction(isDefaultAction: false, child: const Text("확인"),
                                                                                    onPressed: () async{
                                                                                      postCommentsJson[index]["subComments"].removeAt(position);
                                                                                      await firestore.collection('board').doc(widget.uid).update({
                                                                                        "${widget.id}.comments" : postCommentsJson,
                                                                                        "${widget.id}.theNumberOfComments" : post.theNumberOfComments! -1
                                                                                      }).whenComplete(() {
                                                                                        setState((){
                                                                                          Get.back();
                                                                                          focusNode.unfocus();
                                                                                        });
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            });
                                                                            break;
                                                                          }
                                                                        },
                                                                        itemBuilder: (BuildContext context) {
                                                                          return {'삭제'}.map((String choice) {
                                                                            return PopupMenuItem<String>(
                                                                              value: choice,
                                                                              child: Text(choice),
                                                                            );
                                                                          }).toList();
                                                                        },
                                                                      ) : Container(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 8,bottom: 8),
                                                                child: Text(post.comments![index]!.subComments![position]!.content!,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                              ),
                                                              Text(post.comments![index]!.subComments![position]!.date!,style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035),)
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
                                    postCommentsJson[commentIndex!]["subComments"].add(
                                        SubComment(
                                            userName: widget.person.userName,
                                            userPermission: widget.person.userPermission,
                                            uid: widget.person.uid,
                                            id: getRandomString(12),
                                            date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()).toString(),
                                            content: commentController.text,
                                        ).toJson()
                                    );

                                    await firestore.collection('board').doc(widget.uid).update({
                                      "${widget.id}.comments" : postCommentsJson,
                                      "${widget.id}.theNumberOfComments" : post.theNumberOfComments! +1
                                    }).whenComplete(() => setState((){
                                      commentIndex = null;
                                      commentHintText = "댓글을 입력하세요";
                                    }));

                                  }else{
                                    postCommentsJson.add(
                                        Comment(
                                            userName: widget.person.userName,
                                            userPermission: widget.person.userPermission,
                                            uid: widget.person.uid,
                                            id: getRandomString(12),
                                            date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()).toString(),
                                            subComments: [],
                                            content: commentController.text
                                        ).toJson()
                                    );

                                    await firestore.collection('board').doc(widget.uid).update({
                                      "${widget.id}.comments" : postCommentsJson,
                                      "${widget.id}.theNumberOfComments" : post.theNumberOfComments! +1
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

    var boardData = await firestore.collection('board').doc(widget.uid).get();

    post = Post.fromJson(boardData.data()![widget.id]);

    bool shouldUpdate = false;

    for(Comment? i in post.comments!){
      var commentUser = await currentUserData(i!.uid!);

      if(i.userName != commentUser["userName"]){

        i.userName = commentUser["userName"];
        shouldUpdate = true;

      }

      if(i.userPermission != commentUser["userPermission"]){

        i.userPermission = commentUser["userPermission"];
        shouldUpdate = true;

      }

      for(SubComment? j in i.subComments!){
        var subCommentUser = await currentUserData(j!.uid!);

        if(j.userName != subCommentUser["userName"]){

          j.userName = subCommentUser["userName"];
          shouldUpdate = true;

        }

        if(j.userPermission != subCommentUser["userPermission"]){

          j.userPermission = subCommentUser["userPermission"];
          shouldUpdate = true;

        }

      }
    }

    postCommentsJson = post.toJson()["comments"];
    if(shouldUpdate)updateCommentUserName(widget.uid, postCommentsJson);

    return true;

  }

   currentUserData(String id) async{
    return await firestore.collection('users').doc(id).get().then((value) => value.data());
  }

  updateCommentUserName(String uid,List commentsJson) async{
    await firestore.collection('board').doc(uid).update({
      "${widget.id}.comments" : postCommentsJson,
    });
  }

}
