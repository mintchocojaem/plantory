import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:plantory/views/home/home_page.dart';

import '../../data/person.dart';
import '../../data/plant.dart';

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
                resizeToAvoidBottomInset: false,
                body: Center(
                  child: FutureBuilder(
                    future: getUserData(user),
                    builder:(BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData == false){
                        return CircularProgressIndicator();
                      }else if(snapshot.hasError){
                        return CircularProgressIndicator();
                      }else{
                        return HomePage(person: snapshot.data[0], plantsInfo: snapshot.data[1]);
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

  Future<List> getUserData(User user) async{
    late Person person;
    CollectionReference usersCollection = firestore.collection('users');
    DocumentSnapshot userData = await usersCollection.doc(user.uid).get();
    var plantsInfo = await firestore.collection('plants').get().then((value) => value.docs.map((e) => e.data()).toList());
    if(userData.exists){
      person = Person(
        uid: userData["uid"],
        email: userData["email"],
        userName: userData["userName"],
        userPermission: userData["userPermission"],
        plants: plantsFromJson(userData["plants"]),
      );
      print("Got user");
    }else{
      await usersCollection.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'userName': (user.displayName == "" || user.displayName == null) ? "User" : user.displayName,
        'userPermission': "user",
        'plants': []
      }).whenComplete(() {
        person = Person(
          uid:  user.uid,
          email: user.email,
          userName: (user.displayName == "" || user.displayName == null) ? "User" : user.displayName,
          userPermission: "user",
          plants: [],
        );
        print("Init user");
      });
    }
    return [person, plantsInfo];
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


