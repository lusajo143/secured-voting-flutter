import 'dart:async';

import 'package:flutter/material.dart';
import 'package:op/Views/Before/Login.dart';



class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 2), () => {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login()))
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              Text("Secured Voting",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
