//dart 기본 패키지
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//dart firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:plantory/views/index_page.dart';

import '../../data/person.dart';
import '../../data/plant.dart';

/*
List<Plant> plantList = [

  Plant(
    id: 0,
    image: null,
    pinned: true,
    name: "로꼬",
    type: "다육이",
    date: "2022-07-27",
    note: null,
    cycles:[
      {
        Cycles.id.name : 0,
        Cycles.type.name : "물",
        Cycles.cycle.name : "7",
        Cycles.startDate.name : "2022-07-27",
        Cycles.init.name : false,
      },
      {
        Cycles.id.name : 1,
        Cycles.type.name : "분갈이",
        Cycles.cycle.name : "30",
        Cycles.startDate.name : "2022-07-28",
        Cycles.init.name : false
      },
    ],
    timelines: List.empty(growable: true),
  ),

];
*/

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return SignInScreen(
                  providerConfigs: [
                    EmailProviderConfiguration(),
                    GoogleProviderConfiguration(clientId: "988507898334-pfl1fa0c8jp94l2sdlqaieqohg4s178d.apps.googleusercontent.com"),
                  ],
              );
            }else if(snapshot.hasError){
              return Container();
            }
            else{

              final FirebaseAuth auth = FirebaseAuth.instance;
              final User user = auth.currentUser!;

              return Scaffold(
                body: Center(
                  child: FutureBuilder(
                    future: getUserData(user),
                    builder:(BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData == false){
                        return CircularProgressIndicator();
                      }else if(snapshot.hasError){
                        return CircularProgressIndicator();
                      }else{
                        return IndexPage(person: snapshot.data,);
                      }
                    }
                  ),
                ),
              );
            }
          }
        )
    );
  }

  Future<Person> getUserData(User user) async{
    late Person person;
    CollectionReference usersCollection = firestore.collection('users');
    DocumentSnapshot userData = await usersCollection.doc(user.uid).get().whenComplete(() => null);
    if(userData.exists){
      person = Person(
        uid: userData["uid"],
        email: userData["email"],
        name: userData["name"],
        permission: userData["permission"],
        image: userData["image"],
        plants: plantsFromJson(userData["plants"]),
      );
      print("Got user");
    }else{
      await usersCollection.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': (user.displayName == "" || user.displayName == null) ? "User" : user.displayName,
        'permission': "user",
        'image': null,
        'plants': []
      }).whenComplete(() {
        person = Person(
          uid:  user.uid,
          email: user.email,
          name: (user.displayName == "" || user.displayName == null) ? "User" : user.displayName,
          permission: "user",
          image: null,
          plants: [],
        );
        print("Init user");
      });
    }
    return person;
  }

  List<Plant> plantsFromJson(List? plants){
    List<Plant> result = List.empty(growable: true);
    if(plants != null){
      for(int i = 0; i < plants.length; i++){
        result.add(Plant.fromJson(plants[i]));
      }
      return result;
    }else{
      return [];
    }
  }

}


