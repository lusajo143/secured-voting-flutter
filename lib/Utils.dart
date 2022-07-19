

import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot> getUserDetails(String id) async {
  final user = await FirebaseFirestore.instance.collection("voters").doc(id).get();
  return user;
}
