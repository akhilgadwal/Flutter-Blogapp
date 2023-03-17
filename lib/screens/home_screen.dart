import 'package:exblogapp/screens/login_screen.dart';
import 'package:exblogapp/screens/upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //creating the refrence
  final firedb = FirebaseDatabase.instance.ref().child('Posts');
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController searchcontroller = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text("B L O G"),
          ),
          actions: [
            InkWell(
                child: const Icon(Icons.logout_outlined),
                onTap: () {
                  auth.signOut().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  });
                })
          ],
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadScreen()));
            }),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                controller: searchcontroller,
                decoration: const InputDecoration(
                  labelText: 'search',
                  border: OutlineInputBorder(),
                  hintText: 'search with title',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (String value) {
                  setState(() {});
                  search = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: FirebaseAnimatedList(
                      query: firedb.child('post list'),
                      itemBuilder: (context, snapshot, animation, index) {
                        Map map = snapshot.value as Map;
                        String temptitle = map['pTitle'];
                        if (searchcontroller.text.isEmpty) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Card(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Title:  ' + map['pTitle'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('Email : ' + map['uEmail'])
                                            ]),
                                      ),
                                      Card(
                                        color: Colors.black,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FadeInImage.assetNetwork(
                                              height: 250,
                                              width: double.infinity,
                                              placeholder:
                                                  'lib/assets/images/blogapplogo.png',
                                              image: map['pImage']),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Descriptions ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              map['pDescription'],
                                              style: TextStyle(fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                              ));
                          ;
                        } else if (temptitle
                            .toLowerCase()
                            .contains(searchcontroller.text.toString())) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Card(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Title:  ' + map['pTitle'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('Emai : ' + map['uEmail'])
                                            ]),
                                      ),
                                      Card(
                                        color: Colors.black,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FadeInImage.assetNetwork(
                                              height: 250,
                                              width: double.infinity,
                                              placeholder:
                                                  'lib/assets/images/blogapplogo.png',
                                              image: map['pImage']),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Descriptions ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              map['pDescription'],
                                              style: TextStyle(fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                              ));
                        } else {
                          return Container();
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
