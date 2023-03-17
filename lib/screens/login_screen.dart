import 'package:exblogapp/screens/home_screen.dart';
import 'package:exblogapp/screens/options_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/round_button.dart';
import 'resetscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  //show spinner
  bool showspinner = false;
  //creating controls
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  //storing the value
  //gloabl key
  final formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(child: const Text('Login'))),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(colors: [
                          Colors.blue.shade100,
                          Colors.purple.shade200
                        ])),
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            //margin: EdgeInsets.all(10),
                            height: 60,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'L O G I N U S E R',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ),
                          ),
                          Form(
                            key: formkey,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailcontroller,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                      hintText: 'E N T E R E M A I L',
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? 'enter email'
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    controller: passcontroller,
                                    decoration: const InputDecoration(
                                      labelText: 'password',
                                      border: OutlineInputBorder(),
                                      hintText: 'E N T E R P A S S W O R D',
                                      prefixIcon: Icon(Icons.lock),
                                    ),
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? 'valid password'
                                          : null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Roundbuttons(
                              onpress: () async {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    showspinner = true;
                                  });
                                  try {
                                    final user =
                                        await auth.signInWithEmailAndPassword(
                                            email: email.toString().trim(),
                                            password:
                                                password.toString().trim());

                                    if (user != null) {
                                      print('Sucess');
                                      toastmessage(
                                          'User logged in  Successfully');
                                      setState(() {
                                        showspinner = false;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    setState(() {
                                      showspinner = false;
                                    });
                                    print(e.toString());
                                    toastmessage(e.toString());
                                  }
                                }
                              },
                              text: 'LOGIN'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen2()));
                                  },
                                  child:
                                      Text('F O R G E T   P A S S W O R D ?')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OptionsScreen()));
                                  },
                                  child: Text('Main'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toastmessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
