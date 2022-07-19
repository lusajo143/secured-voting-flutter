import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:op/Views/Splash.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Mobile App',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final Stream<QuerySnapshot> _voters = FirebaseFirestore.instance.collection("voters").snapshots();


  // Future<void> _getUsers() async {
  //   ref.get().
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: StreamBuilder<QuerySnapshot>(
          stream: _voters,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
            if (snapShot.hasError) {
              return Text("Error");
            }
            else if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            }
            else if (snapShot.hasData) {

              List<QueryDocumentSnapshot> users = snapShot.data!.docs;
              for (int i = 0; i < users.length; i++) {
                print(users[i].get("fullname"));
              }
              return Text("Data");
              // return ListView(
              //   children: snapShot.data!.docs.map((DocumentSnapshot document) {
              //     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              //     return ListTile(
              //       title: Text(data['fullname']),
              //       // subtitle: Text(data['company']),
              //     );
              //   }).toList(),
              // );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
