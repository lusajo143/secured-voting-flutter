import 'package:flutter/material.dart';

class VoteComplete extends StatefulWidget {
  const VoteComplete({Key? key}) : super(key: key);

  @override
  State<VoteComplete> createState() => _VoteCompleteState();
}

class _VoteCompleteState extends State<VoteComplete> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Done'),
    );
  }
}

