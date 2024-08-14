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

  Stream<int> getPointStream() {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(0);
    }
    return _firestore
        .collection('user_list')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['point'] as int? ?? 0);
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
            'myPoints'.tr,
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: StreamBuilder<int>(
                stream: getPointStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  if (snapshot.hasError) {
                    return Text('Error', style: TextStyle(color: Colors.white));
                  }
                  final user = FirebaseAuth.instance.currentUser;
                  String pointsText;

                  if (user == null || user.isAnonymous) {
                    pointsText = '--';
                  } else {
                    int points = snapshot.data ?? 0; // 处理 null 值的情况
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