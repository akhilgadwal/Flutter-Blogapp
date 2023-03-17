import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/round_button.dart';
import 'options_screen.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  //taking firebase auth refral
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
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(child: const Text('Create Account'))),
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
                height: 350,
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
                            'R E G I S T E R',
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
                      Roundbuttons(
                          onpress: () async {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                showspinner = true;
                              });
                              try {
                                final user =
                                    await auth.createUserWithEmailAndPassword(
                                        email: email.toString().trim(),
                                        password: password.toString().trim());

                                print('Sucess');
                                toastmessage('User Created Successfully');
                                if (user != null) {
                                  setState(() {
                                    showspinner = false;
                                  });
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
                          text: 'Confirm'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OptionsScreen()));
                          },
                          child: Text('Main'))
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
