import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeUserName extends StatefulWidget {
  const HomeUserName({Key? key}) : super(key: key);

  @override
  _HomeUserNameState createState() => _HomeUserNameState();
}

class _HomeUserNameState extends State<HomeUserName> {
  String displayName = 'Welcome!';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      setState(() {
        displayName = 'anonymousUser'.tr;
      });
    } else {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('user_list')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          setState(() {
            displayName = data?['name'] ?? 'loading'.tr;
          });
        }
      } catch (e) {
        setState(() {
          displayName = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        displayName,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: Color(0xFFF26101),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}