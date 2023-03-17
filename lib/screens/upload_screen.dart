import 'dart:core';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_store;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showspinner = false;
  final postRef = FirebaseDatabase.instance.ref().child('Posts');

  firebase_store.FirebaseStorage storage =
      firebase_store.FirebaseStorage.instance;
  //for images
  File? images;
  //imagee picker
  final picker = ImagePicker();
  //creating controller
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  //creating function s
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        images = File(pickedFile.path);
      } else {
        print('No images is selected');
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        images = File(pickedFile.path);
      } else {
        print('No images is captured');
      }
    });
  }

  //form keys
  final formkey = GlobalKey<FormState>();
  //creating function for dialogbox
  void dialogbox(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          height: 120,
          child: Column(children: [
            InkWell(
              onTap: () {
                getImageCamera();
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(Icons.camera),
                title: const Text('Camera'),
              ),
            ),
            InkWell(
              onTap: () {
                getImageGallery();
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(Icons.photo_album),
                title: const Text('Gallery'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(' Add new post'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    onTap: () => dialogbox(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.height * 1,
                      child: images != null
                          ? ClipRect(
                              child: Image.file(
                                images!.absolute,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.camera_enhance,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: 10,
                        controller: titlecontroller,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter Post Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return value!.isEmpty ? 'enter title' : null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: descontroller,
                        decoration: const InputDecoration(
                          labelText: 'Descriptions',
                          hintText: 'Details',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return value!.isEmpty
                              ? 'enter proper descriptions'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () async {
                      setState(
                        () {
                          showspinner = true;
                        },
                      );
                      try {
                        int date = DateTime.now().millisecond;
                        firebase_store.Reference ref = firebase_store
                            .FirebaseStorage.instance
                            .ref('/newappblog$date');
                        UploadTask uploadTask = ref.putFile(images!.absolute);
                        await Future.value(uploadTask);
                        var newurl = await ref.getDownloadURL();
                        final User? user = auth.currentUser;
                        postRef.child('post list').child(date.toString()).set({
                          'pID': date.toString(),
                          'pImage': newurl.toString(),
                          'pTime': date.toString(),
                          'pTitle': titlecontroller.text.toString(),
                          'pDescription': descontroller.text.toString(),
                          'uEmail': user!.email.toString(),
                          'uId': user.uid.toString(),
                        }).then((value) {
                          toastmessage('Post published');
                          setState(() {
                            showspinner = false;
                          });
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
                        toastmessage(e.toString());
                      }
                    },
                    child: const Text(
                      'S U B M I T',
                      style: TextStyle(fontSize: 20),
                    ))
              ],
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
