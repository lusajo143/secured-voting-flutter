import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Utils.dart';
import 'Authentication.dart';

class Blockleader extends StatefulWidget {
  final String presId, govId;
  const Blockleader({Key? key, required this.presId, required this.govId}) : super(key: key);

  @override
  State<Blockleader> createState() => _BlockleaderState();
}

class _BlockleaderState extends State<Blockleader> {
  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> blockleader =
    FirebaseFirestore.instance.collection("BlockLeader").snapshots();
    final width = MediaQuery.of(context).size.width * 0.45;
    return SafeArea(child: Scaffold(

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
                  "3.Sellect Block leader",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: blockleader,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapShot) {
                if (snapShot.hasError) {
                  return Center(
                    child: Text('Internet connection error!'),
                  );
                } else if (snapShot.hasData) {

                  List<QueryDocumentSnapshot> blockDocs = [];

                  snapShot.data!.docs.forEach((b) {
                    if (b.get('block') == "2") blockDocs.add(b);
                  });

                  return Container(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 20),
                    child: GridView.builder(gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(

                      maxCrossAxisExtent: width,
                      crossAxisSpacing: 10,
                      childAspectRatio: width/(width+50)
                    ),
                        itemCount: blockDocs.length,
                        itemBuilder: (context, index){

                      return InkWell(

                        child: FutureBuilder(
                          future: getUserDetails(
                              blockDocs[index].get('id')),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Internet connection error!');
                            } else if (snapshot.hasData) {
                              return SizedBox(
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
                                      snapshot.data!.get("block"),
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

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Authentication(presId: widget.presId,
                                  govId: widget.govId, blockId: blockDocs[index].id,)));
                        },
                      );
                        }),
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
