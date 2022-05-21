import 'package:chatapp/screens/chat.dart';
import 'package:chatapp/wedgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class RegistrationScreen extends StatefulWidget {
  static const screenRoute = 'registration';

  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreen createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen > {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool spinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 180,
                  child: Image.asset('images/logo.png'),
                ),
              ),

              Padding(

                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value){
                    email = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    border: OutlineInputBorder(),

                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  onChanged: (value){
                    password = value;
                  },
                  decoration: InputDecoration(

                    hintText: 'Enter your Password',
                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    border: OutlineInputBorder(),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(color: Colors.black38,
                    title: 'Register',
                    onPressed: ()async{
                  setState(() {
                    spinner = true;
                  });

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    Navigator.pushNamed(context, ChatScreen.screenRoute);
                    setState(() {
                      spinner = false;
                    });
                  }
                  catch(e){
                    print(e);
                  }
                    }),
              )
            ],

          ),
        ),
      ),
    );
  }
}
