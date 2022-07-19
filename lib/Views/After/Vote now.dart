import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Utils.dart';
import 'Governor.dart';

class votenow extends StatefulWidget {
  const votenow({Key? key}) : super(key: key);

  @override
  State<votenow> createState() => _votenowState();
}

class _votenowState extends State<votenow> {
  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> presidents = FirebaseFirestore.instance.collection("President").snapshots();
    final width = MediaQuery.of(context).size.width * 0.45;

    return SafeArea(
        child: Scaffold(appBar: AppBar(
      elevation: 0,
      title: Text("Secure Voting"),
    ),

      body: Column(
        children: [
          Container(

            width:double.infinity ,
            // height: 50,
            color: Colors.green,
            child: Container(
              margin: EdgeInsets.only(top: 10,bottom: 10),
                padding: EdgeInsets.only(left: 10),
                child: Text("1.President and Vice President",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18,),)),

          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: presidents,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {

                if (snapShot.hasError) {
                  return Center(child: Text('Internet connection error!'),);
                } else if (snapShot.hasData) {
                  List<QueryDocumentSnapshot> presDocs = snapShot.data!.docs;
                   return ListView.builder(
                     itemCount: presDocs.length,
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
                                future: getUserDetails(presDocs[index].get('id')),
                                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  
                                  if (snapshot.hasError) {
                                    return Text('Internet connection error!');
                                  } else if (snapshot.hasData) {
                                    return Container(
                                      width: width,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: Image.network(snapshot.data!.get("profile"),
                                              width: double.infinity,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 3,),
                                          Text(snapshot.data!.get("fullname"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold

                                          ),),
                                          Text("President",textAlign: TextAlign.center,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold),),
                                          Text(snapshot.data!.get("prog"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black38

                                          ),)

                                        ],
                                      ),
                                    );
                                  }
                                  
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Governor(presId: presDocs[index].id,)));

                              },
                            ),
                             SizedBox(
                               height: 10,
                             ),
                             FutureBuilder(
                               future: getUserDetails(presDocs[index].get('viceId')),
                               builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                 if (snapshot.hasError) {
                                   return Text('Internet connection error!');
                                 } else if (snapshot.hasData) {
                                   return Container(
                                     width: width,
                                     child: Column(
                                       children: [
                                         ClipRRect(
                                           borderRadius: const BorderRadius.all(Radius.circular(10)),
                                           child: Image.network(snapshot.data!.get("profile"),
                                             width: double.infinity,
                                             height: 150,
                                             fit: BoxFit.cover,
                                           ),
                                         ),
                                         SizedBox(height: 3,),
                                         Text(snapshot.data!.get("fullname"),
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                               color: Colors.blue,
                                               fontWeight: FontWeight.bold

                                           ),),
                                         Text("Vice President",textAlign: TextAlign.center,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold),),
                                         Text(snapshot.data!.get("prog"),
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                               color: Colors.black38

                                           ),)

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
