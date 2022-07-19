import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Utils.dart';
import 'Blockleader.dart';

class Governor extends StatefulWidget {
  final String presId;
  const Governor({Key? key, required this.presId}) : super(key: key);

  @override
  State<Governor> createState() => _GovernorState();
}

class _GovernorState extends State<Governor> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> governor =
        FirebaseFirestore.instance.collection("Governor").snapshots();
    final width = MediaQuery.of(context).size.width * 0.45;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Secure Voting"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            // height: 50,
            color: Colors.green,
            child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "2.Governor",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: governor,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapShot) {
                if (snapShot.hasError) {
                  return Center(
                    child: Text('Internet connection error!'),
                  );
                } else if (snapShot.hasData) {
                  List<QueryDocumentSnapshot> govDocs = snapShot.data!.docs;
                  return ListView.builder(
                    itemCount: govDocs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // SizedBox(
                            //   height: 10,
                            // ),

                            InkWell(
                              child: FutureBuilder(
                                future: getUserDetails(
                                    govDocs[index].get('id')),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Internet connection error!');
                                  } else if (snapshot.hasData) {
                                    return Container(
                                      width: width,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: Image.network(
                                              snapshot.data!.get("profile"),
                                              width: double.infinity,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            snapshot.data!.get("fullname"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Governor",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            snapshot.data!.get("prog"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )
                                        ],
                                      ),
                                    );
                                  }

                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Blockleader(presId: widget.presId, govId: govDocs[index].id,)));
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              future:
                                  getUserDetails(govDocs[index].get('viceId')),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Internet connection error!');
                                } else if (snapshot.hasData) {
                                  return Container(
                                    width: width,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image.network(
                                            snapshot.data!.get("profile"),
                                            width: double.infinity,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          snapshot.data!.get("fullname"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " Vice Governor",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.get("prog"),
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.black38),
                                        )
                                      ],
                                    ),
                                  );
                                }

                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      );
                    },
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
          // Expanded(child: GridView.builder(gridDelegate: Sl, itemBuilder: itemBuilder))
        ],
      ),
    ));
  }
}
