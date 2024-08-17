import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeMyPoint extends StatefulWidget {
  const HomeMyPoint({Key? key}) : super(key: key);

  @override
  _HomeMyPointState createState() => _HomeMyPointState();
}

class _HomeMyPointState extends State<HomeMyPoint> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a stream that listens to the 'point' field in the user's document
  Stream<int> getPointStream() {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(0); // Return a stream with a default value of 0 if no user is logged in
    }
    return _firestore
        .collection('user_list')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['point'] as int? ?? 0); // Map the document data to the 'point' field
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF91BED4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'myPoints'.tr, // Display the translated 'myPoints' text
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: StreamBuilder<int>(
                stream: getPointStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.white); // Show a loading indicator while waiting for data
                  }
                  if (snapshot.hasError) {
                    return Text('Error', style: TextStyle(color: Colors.white)); // Show an error message if there is an error
                  }
                  final user = FirebaseAuth.instance.currentUser;
                  String pointsText;

                  if (user == null || user.isAnonymous) {
                    pointsText = '--'; // Display '--' if user is not logged in or is anonymous
                  } else {
                    int points = snapshot.data ?? 0; // Handle null values by defaulting to 0
                    pointsText = points.toString();
                  }

                  return Text(
                    pointsText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
