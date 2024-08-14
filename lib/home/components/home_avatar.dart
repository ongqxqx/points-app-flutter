import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class HomeAvatar extends StatefulWidget {
  const HomeAvatar({Key? key}) : super(key: key);

  @override
  _HomeAvatarState createState() => _HomeAvatarState();
}

class _HomeAvatarState extends State<HomeAvatar> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDocumentFuture;

  @override
  void initState() {
    super.initState();
    _userDocumentFuture = _fetchUserDocument();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .get();
    } else {
      throw Exception('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _userDocumentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return CircularProgressIndicator(); // 或者其他的占位符
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        String avatarID = DateTime.now().millisecondsSinceEpoch.toString(); // Default avatarID
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data()!;
          avatarID = data['avatarID'] ?? avatarID;
        }

        return Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: RandomAvatar(
            avatarID,
            width: 50,  // 调整宽度和高度
            height: 50,
          ),
        );
      },
    );
  }
}
