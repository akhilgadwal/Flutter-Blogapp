import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/round_button.dart';
import 'resetscreen.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  FirebaseAuth auth = FirebaseAuth.instance;
  //show spinner
  bool showspinner = false;
  //creating controls
  TextEditingController emailcontroller = TextEditingController();

  //storing the value
  //gloabl key
  final formkey = GlobalKey<FormState>();
  String email = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(child: const Text('Rest Password'))),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade100,
                      Colors.purple.shade200
                    ])),
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //margin: EdgeInsets.all(10),
                        height: 60,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'P A S S W O R D ',
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
                                  return value!.isEmpty ? 'enter email' : null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Roundbuttons(
                          onpress: () async {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                showspinner = true;
                              });
                              try {
                                auth
                                    .sendPasswordResetEmail(
                                  email: email.toString().trim(),
                                )
                                    .then((value) {
                                  setState(() {
                                    showspinner = false;
                                  });
                                  toastmessage('Please check email');
                                }).onError((error, stackTrace) {
                                  toastmessage(error.toString());
                                  setState(() {
                                    showspinner = false;
                                  });
                                });
                              } catch (e) {
                                setState(() {
                                  showspinner = false;
                                });
                                print(e.toString());
                                toastmessage(e.toString());
                              }
                            }
                          },
                          text: 'R E S T'),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
