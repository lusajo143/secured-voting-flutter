import 'package:flutter/material.dart';
import 'package:op/Views/After/Vote%20now.dart';

class Voting extends StatefulWidget {
  const Voting({Key? key}) : super(key: key);

  @override
  State<Voting> createState() => _VotingState();
}

class _VotingState extends State<Voting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Secure Voting'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 30
              ),
              child: Row(
                children: const [
                  Icon(Icons.circle,color: Colors.green,size: 20,),
                  SizedBox(width: 5,),
                  Text("Voting Progress",style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            Divider(),
            
            Expanded(
              child: Center(
                child: Text("You have not voted yet!",textAlign: TextAlign.center,),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 20),
              // color: Colors.blue,
              margin: EdgeInsets.only(left: 10,right: 10,top: 30),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)
                ),

                onPressed: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>votenow()));
                },

                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.how_to_vote, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text("VOTE NOW",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
