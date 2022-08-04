import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:plantory/views/community/post_add_page.dart';
import 'package:plantory/views/community/post_detail_page.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../../data/person.dart';
import '../../data/post.dart';

class CommunityPage extends StatefulWidget{

  const CommunityPage({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CommunityPage();
  }

}

class _CommunityPage extends State<CommunityPage>{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<int> commentCounter = List.empty(growable: true);
  List<String> postUserNames = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Community",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
            child: Center(
              child: FutureBuilder(
                future: getBoardData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData == false){
                    return CircularProgressIndicator();
                  }else if(snapshot.hasError){
                    return CircularProgressIndicator();
                  }else{
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context,int index) {
                          return GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Divider(),
                                Container(
                                  child: ListTile(
                                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                    dense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data[index].title,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.034))
                                      ],
                                    ),
                                    subtitle: Text(snapshot.data[index].content,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.032),),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(snapshot.data[index].date,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black54),),
                                        Text(" | ",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black54)),
                                        Text(postUserNames[index],style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black54)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.thumb_up, size: MediaQuery.of(context).size.width * 0.035, color: Colors.black54,),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4,left: 4),
                                              child: Text(snapshot.data[index].like.length.toString(), style: TextStyle(color: Colors.black54),),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.comment_rounded, size: MediaQuery.of(context).size.width * 0.035, color: Colors.black54,),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4,left: 4),
                                              child: Text(commentCounter[index].toString(), style: TextStyle(color: Colors.black54),),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                index == snapshot.data.indexOf(snapshot.data.last) ? Divider() : Container() //이부분 마지막에 바꿔야함
                              ],
                            ),
                            onTap: (){
                              Get.to(() => PostDetailPage(uid: snapshot.data[index].uid,id: snapshot.data[index].id,person: widget.person,))?.then((value) => setState((){}));
                            },
                          );
                        }
                    );
                  }
                }
              ),
            ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => PostAddPage(person: widget.person,))?.then((value) => setState((){}));
        },
        heroTag: null,
        child: Icon(Icons.add),backgroundColor: primaryColor,),
    );

  }

  getBoardData() async{
    List<Post> result = List.empty(growable: true);
    List<String> tempPostUserNames = List.empty(growable: true);
    List<int> tempCommentsNumber = List.empty(growable: true);

    var boardData = await firestore.collection('board').get().then((value) => value.docs.map((e) => e.data().values).toList());

    var usersCollection = firestore.collection('users');
    for(var i in boardData){
     for(var j in i){
       await usersCollection.doc(j["uid"]).get().then((value) => result.add(
           Post.fromJson(j)
       ));
     }
    }
    result.sort((b,a) => (DateFormat('yyyy-MM-dd-HH-mm-ss').parse(a.date!))
        .compareTo((DateFormat('yyyy-MM-dd-HH-mm-ss').parse(b.date!))));

    if(result.isNotEmpty){
      for(Post i in result){
        String name = await usersCollection.doc(i.uid).get().then((value) => value["name"]);
        tempPostUserNames.add(name);
        if(i.comments!.isNotEmpty){
          int tempCounter = 0;

          for(int j = 0; j < i.comments!.length; j++){
            tempCounter++;
            if(i.comments![j]!.subComments!.isNotEmpty){
              for(int k = 0; k < i.comments![j]!.subComments!.length; k++){
                tempCounter++;
              }
            }
          }
          tempCommentsNumber.add(tempCounter);
        }else{
          tempCommentsNumber.add(0);
        }
      }
    }
    postUserNames = tempPostUserNames;
    commentCounter = tempCommentsNumber;

    return result;
  }


}
