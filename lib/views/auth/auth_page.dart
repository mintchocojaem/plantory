//dart 기본 패키지
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//dart firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:plantory/views/index_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

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
            }
            return IndexPage();
          }
        )
    );
  }
}

