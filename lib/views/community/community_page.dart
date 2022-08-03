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

class CommunityPage extends StatefulWidget{

  const CommunityPage({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CommunityPage();
  }

}

class _CommunityPage extends State<CommunityPage>{

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  //late DocumentSnapshot<Map<String,dynamic>> boardData;
  var boardData;

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
                    return Container();
                  }else{
                    return ListView.builder(
                        itemCount: 1,
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
                                        Text("제 식물상태가 이상합니다",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.034))
                                      ],
                                    ),
                                    subtitle: Text("이파리가 시들시들해요 어떻게 하죠?",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.032),),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("2022/08/03",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black54),),
                                        Text(" | ",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black54)),
                                        Text("User",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035,color: Colors.black54)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.thumb_up, size: MediaQuery.of(context).size.width * 0.035, color: Colors.black54,),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4,left: 4),
                                              child: Text("5", style: TextStyle(color: Colors.black54),),
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
                                              child: Text("10", style: TextStyle(color: Colors.black54),),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                index == 0 ? Divider() : Container() //이부분 마지막에 바꿔야함
                              ],
                            ),
                            onTap: (){
                              Get.to(() => PostDetailPage());
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
          Get.to(() => PostAddPage());
        },
        heroTag: null,
        child: Icon(Icons.add),backgroundColor: primaryColor,),
    );

  }

  getBoardData() async{
    //return boardData = await firestore.collection('board').doc("first").get();
    return true;
  }




}
