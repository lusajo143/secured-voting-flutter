import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../After/Home.dart';

class ChangePassword extends StatefulWidget {
  final String voterId;
  const ChangePassword({Key? key, required this.voterId}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _pass = TextEditingController(),
      _cpass = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  bool isLoading = false;

  Future<bool> changePassword() async {
    setState(() => {isLoading = true});
    await FirebaseFirestore.instance
        .collection("voters")
        .doc(widget.voterId)
        .update({"password": _pass.value.text, "hasChangedPassword": true})
        .then((value) => {
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Home(voterId: widget.voterId)))
            })
        .catchError((onError) => {
              showDialog(
                  context: context,
                  builder: (context) {
                    setState(() => {
                      isLoading = false
                    });
                    return AlertDialog(
                      title: Text('Connection Error'),
                      content: Text('Check your internet conection!'),
                    );
                  })
            });

    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Secure Voting'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(

                        color: Colors.blue,
                        shape: BoxShape.circle

                    ),
                    child: Container(
                      alignment: Alignment.center,

                      child: Icon(Icons.lock,size: 60,color: Colors.white,),
                    ),

                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(

                    child: Text(
                        'You have login using your default password, for'
                            ' security reasons your required to change your password before proceeding.',
                    textAlign: TextAlign.center,
                    style: TextStyle(),),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("New password must be 8 characters length",style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),




                  TextFormField(
                    controller: _pass,
                    validator: (value) {
                      if (value == '') {
                        return 'Enter your new password here';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        label: Text("New Password"),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        hintText: '*******',
                        contentPadding: EdgeInsets.all(10)),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _cpass,
                    validator: (value) {
                      if (value == '') {
                        return 'Confirm your new password here';
                      } else if (value != _pass.value.text) {
                        return "Password doesn't match";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        label: Text("Confirm Password"),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        hintText: '*******',
                        contentPadding: EdgeInsets.all(10)),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: !isLoading
                        ? TextButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                await changePassword();
                              }
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            child: Text(
                              'Change Password',
                              style: TextStyle(color: Colors.white,),
                            ),
                          )
                        : TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.only(right: 10),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: TextButton(
                                    onPressed: (){},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(),
                                        ),
                                        SizedBox(width: 10,),
                                        Container(
                                          child: Text("Loading",style: TextStyle(color: Colors.black),),
                                        )
                                      ],
                                    ),
                                  ),

                                )
                              ],
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
