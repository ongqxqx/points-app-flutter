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
        displayName = 'anonymousUser'.tr; // Set display name for anonymous users
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
            displayName = data?['name'] ?? 'loading'.tr; // Set display name or 'loading' text
          });
        }
      } catch (e) {
        setState(() {
          displayName = 'Error: $e'; // Display error message if any
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
          fontFamily: 'Roboto', // Font family for text
          fontSize: 18, // Font size for text
          color: Color(0xFFF26101), // Text color
          fontWeight: FontWeight.bold, // Font weight
        ),
      ),
    );
  }
}
