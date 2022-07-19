import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:op/Encryption/Cypher.dart';
import 'package:op/Views/After/Home.dart';
import 'package:op/Views/Before/ChangePassword.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _regno = TextEditingController(),
      _pass = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  bool isLoading = false;

  Future<loginResponse> loginUser() async {
    setState(() => {isLoading = true});
    QuerySnapshot voters =
        await FirebaseFirestore.instance.collection('voters').get();
    List<QueryDocumentSnapshot> docs = voters.docs;
    late String voterId;
    late bool hasChangedPassword;
    bool found = false;
    for (int i = 0; i < docs.length; i++) {
      if (_regno.value.text == docs[i].get("regno") &&
          _pass.value.text == docs[i].get("password")) {
        found = true;
        hasChangedPassword = docs[i].get('hasChangedPassword');
        voterId = docs[i].id;
        break;
      }
    }
    setState(() => {isLoading = false});
    return found
        ? loginResponse(
            voterId: voterId, hasChangedPassword: hasChangedPassword)
        : loginResponse(voterId: "null", hasChangedPassword: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Secured Voting",),
      ),
      body: SafeArea(
  child: SingleChildScrollView(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          child: Stack(
            children: [
            Container(
              child: Image.asset("assets/udom.jpg",width: double.infinity,height: double.infinity,fit: BoxFit.cover,),
            ),
              Container(
                width: double.infinity,
                color: Colors.blue.withOpacity(0.6),
              ),
              Container(
               alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 30),
                child: Text("Log in",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
              )
            ],
          ),


        ),
      Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _regno,
                  validator: (value) {
                    if (value == '') {
                      return 'Enter registration number here';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Text("Registration Number"),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'T/UDOM/2019/00343',
                      contentPadding: EdgeInsets.all(10)),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _pass,
                  validator: (value) {
                    if (value == '') {
                      return 'Enter your password here';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Text("Password"),
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
                        loginResponse response = await loginUser();
                        if (response.voterId != "null" &&
                            !response.hasChangedPassword) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword(
                                      voterId: response.voterId)));
                        } else if (response.voterId != "null" &&
                            response.hasChangedPassword) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Home(voterId: response.voterId)));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Wrong registration number or password'),
                                );
                              });
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : Container(
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
                )
              ],
            ),
          ),
        ),
      ],
    ),
  ),
      ),
    );
  }
}

class loginResponse {
  final String voterId;
  final bool hasChangedPassword;

  loginResponse({required this.voterId, required this.hasChangedPassword});

  // factory loginResponse.toJson(String)

}
