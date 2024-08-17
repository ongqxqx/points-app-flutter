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
  // Future to hold the user document snapshot
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDocumentFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch user document
    _userDocumentFuture = _fetchUserDocument();
  }

  // Method to fetch the user document from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Return the document snapshot for the current user
      return await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .get();
    } else {
      throw Exception('No user logged in'); // Handle case where no user is logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _userDocumentFuture,
      builder: (context, snapshot) {
        // Show a loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return CircularProgressIndicator(); // 或者其他的占位符
        }

        // Handle errors if they occur
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Default avatarID if not present in the Firestore document
        String avatarID = DateTime.now().millisecondsSinceEpoch.toString();
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data()!;
          avatarID = data['avatarID'] ?? avatarID; // Use avatarID from Firestore if available
        }

        // Return the avatar widget with a default or fetched avatarID
        return Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: RandomAvatar(
            avatarID,
            width: 50,  // Adjust width and height
            height: 50,
          ),
        );
      },
    );
  }
}
