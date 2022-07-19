import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:op/Views/After/Voting.dart';

class Home extends StatefulWidget {
  final String voterId;

  const Home({Key? key, required this.voterId}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> voterDetailsStream = FirebaseFirestore
        .instance
        .collection("voters")
        .doc(widget.voterId)
        .snapshots();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Secure Voting'),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Container(

                  child: Image.asset("assets/udom.jpg",width: double.infinity,height: 100,fit: BoxFit.cover,),
                ),
              ),
              SizedBox(
                height: 30
                ,
              ),
              TextButton(onPressed: (){},
                  child: Row(
                    children: [
                      Container(
                        child: Icon(Icons.home,color: Colors.black,size: 35,),
                      ),
                      SizedBox(width: 20,),
                      Text("Dashboard",style: TextStyle(color: Colors.black),)
                    ],
                  )),
              Divider(
                height: 0,
              ),
              TextButton(onPressed: (){
                _key.currentState!.closeDrawer();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Voting()));
              },
                  child: Row(
                    children: [
                      Container(
                        child: Icon(Icons.how_to_vote,color: Colors.black87,size: 35,),
                      ),
                      SizedBox(width: 20,),
                      Text("Voting",style: TextStyle(color: Colors.black87),)
                    ],
                  )),
              Divider(
                height: 0,

              ),
              TextButton(
                  onPressed: (){
                    _key.currentState!.closeDrawer();
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>))
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.logout,color: Colors.black87,size: 35,),
                      SizedBox(width: 20,),
                      Text("Sign out",style: TextStyle(color: Colors.black87),)
                    ],
                  )),
              Divider(
                height: 0,

              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
              stream: voterDetailsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("An error occured");
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Stack(
                          children: [
                            Image.asset(
                              "assets/udom.jpg",
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              height: 150,
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    child: Image.network(
                                      snapshot.data!.get("profile"),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(snapshot.data!.get("fullname"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),



                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Reg. Number: '),
                                    Text(snapshot.data!.get("regno"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),)
                                  ],
                                ),
                                Divider(),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Programme: '),
                                    Text(snapshot.data!.get("prog"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),)
                                  ],
                                ),
                                Divider(),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Year of Study: '),
                                    Text(snapshot.data!.get("yos"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),)
                                  ],
                                ),
                                Divider(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('College: '),
                                    Text(snapshot.data!.get("college"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),)
                                  ],
                                ),

                                Divider(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Voting status: '),
                                    snapshot.data!.get("hasVoted") ? Text("Voted",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        color: Colors.green
                                      ),):
                                        Text('Not Voted',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red
                                        ),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
