import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:op/Utils.dart';
import 'package:op/Views/After/VoteComplete.dart';
import 'package:pinput/pinput.dart';

class Authentication extends StatefulWidget {
  final String presId, govId, blockId;
  const Authentication(
      {Key? key,
      required this.presId,
      required this.govId,
      required this.blockId})
      : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final defaultPinTheme = PinTheme(
    width: 40,
    height: 40,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Future<bool> verify(String email, String code) async {
    var resp = await EmailAuth(sessionName: 'Secured voting').validateOtp(recipientMail: "lusajoshitindi143@gmail.com", userOtp: code);
    return resp;
  }

  late DocumentSnapshot userData;

  void sendOTP() async {
    userData = await getUserDetails('Cy8z5jubid7K96tT2bXX');
    var resp = await EmailAuth(sessionName: 'Secured voting').sendOtp(recipientMail: userData.get('email'));
    resp ? null : sendOTP();
  }
  @override
  void initState() {
    // TODO: implement initState
    sendOTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

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
                  "4. One Time Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'A verification code has been sent to user@gmail.com. Enter verification code to submit your vote.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Pinput(
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            validator: (s) {
              // bool a = await verify("email", "code") ? null : 'Pin is incorrect';
              return "";
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) async {
              bool isVeried = await verify(userData.get('email'), pin);
              if (isVeried) {


                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const VoteComplete())
                );
              } else {
                showDialog(context: context, builder: (context) {
                  return const AlertDialog(
                    content: Text('Wrong verification code'),
                  );
                });
              }
            },
          )
        ],
      ),
    ));
  }
}
