import 'package:chatapp/screens/registration.dart';
import 'package:chatapp/screens/signin.dart';
import 'package:flutter/material.dart';

import '../wedgets/my_button.dart';
class WelcomeScreen extends StatefulWidget {
  static const String screenRute = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key :key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),

                    child: Image.asset('images/logo.png'),
                  ),

                const Text('RetroChat',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
                ),
              ],
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
               color: Colors.black,
               title: 'Sign in',
               onPressed: (){
                 Navigator.pushNamed(context, SignInScreen.screenRoute);
               },
           ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(color: Colors.green,
                  title: 'Register',
                  onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.screenRoute);
                  }),
            ),

          ],
        ),

      ) ,
    );
  }
}
