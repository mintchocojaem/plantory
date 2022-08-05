import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:plantory/views/community/post_add_page.dart';
import 'package:plantory/views/community/post_detail_page.dart';
import 'package:unicons/unicons.dart';
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

  List<Post> posts = List.empty(growable: true);


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
            margin: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
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
                        itemCount: posts.length,//snapshot.data.length,
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
                                        Text(posts[index].title!,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.034))
                                      ],
                                    ),
                                    subtitle: Text(posts[index].content!,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.032),),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(posts[index].date!,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black54),),
                                        Text("    |    ",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black54)),
                                        Text(posts[index].userName! + (posts[index].userPermission == "expert" ? " / 🌱 전문가" : posts[index].userPermission == "admin" ? " / ♠ 관리자" : ""),
                                            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black87)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.thumb_up, size: MediaQuery.of(context).size.width * 0.035, color: Colors.black54,),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4,left: 4),
                                              child: Text(posts[index].like!.length.toString(), style: TextStyle(color: Colors.black54),),
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
                                              child: Text(posts[index].theNumberOfComments!.toString(),
                                                style: TextStyle(color: Colors.black54),),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                index == posts.indexOf(posts.last) ? Divider() : Container()

                              ],
                            ),
                            onTap: (){
                              Get.to(() => PostDetailPage(uid: posts[index].uid!,id: posts[index].id!,person: widget.person,))?.then((value) => setState((){}));
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
    List<Post> temp = List.empty(growable: true);
    var boardData = await firestore.collection('board').get().then((value) => value.docs.map((e) => e.data()));

    var usersCollection = firestore.collection('users');

    for(var i in boardData){
     for(var j in i.values){
       await usersCollection.doc(j["uid"]).get().then((value) {
         temp.add(
           Post.fromJson(j));
       });

     }
    }

    for(Post i in temp){

      var userData = await usersCollection.doc(i.uid).get().then((value) => value.data());

      if(i.userName != userData!["userName"]){

        i.userName = userData["userName"];
        updateUserName(i.uid!,i.id!,userData["userName"]);

      }
      if(i.userPermission != userData["userPermission"]){

        i.userPermission = userData["userPermission"];
        updateUserPermission(i.uid!,i.id!,userData["userPermission"]);

      }
    }
    posts = temp;
    posts.sort((b,a) => (DateFormat('yyyy-MM-dd hh:mm').parse(a.date!))
        .compareTo((DateFormat('yyyy-MM-dd hh:mm').parse(b.date!))));

    return true;
  }

  updateUserName(String uid,String id, String userName) async{
    await firestore.collection('board').doc(uid).update({
      '$id.userName' : userName
    });
  }
  updateUserPermission(String uid,String id, String userPermission) async{
    await firestore.collection('board').doc(uid).update({
      '$id.userPermission' : userPermission
    });
  }

}
