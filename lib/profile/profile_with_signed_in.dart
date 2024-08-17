import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'components/profile_screen/profile_configure_screen.dart';
import 'package:points/profile/components/profile_screen/profile_referral_code.dart';

class ProfileWithSignedInScreen extends StatefulWidget {
  const ProfileWithSignedInScreen({Key? key}) : super(key: key);

  @override
  _ProfileWithSignedInScreenState createState() =>
      _ProfileWithSignedInScreenState();
}

class _ProfileWithSignedInScreenState extends State<ProfileWithSignedInScreen> {
  // Get the currently signed-in user
  final user = FirebaseAuth.instance.currentUser;

  // Stream to listen for user document changes
  Stream<DocumentSnapshot<Map<String, dynamic>>> _userDocumentStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Return a stream of the user document from Firestore
      return FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .snapshots();
    } else {
      // Return an empty stream if no user is signed in
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _userDocumentStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while data is being fetched
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Display an error message if something went wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            // Display a message if no user data is found
            return Center(child: Text('No user data found'));
          }

          // Get user data from the snapshot
          final data = snapshot.data!.data()!;
          final _name = data['name'] ?? '';
          final _avatarID = data['avatarID'] ??
              DateTime.now().millisecondsSinceEpoch.toString();
          final referralCode = user?.uid.substring(0, 5);
          final TextEditingController _referralCodeController =
          TextEditingController();
          _referralCodeController.text = referralCode!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Display the user's avatar
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: RandomAvatar(
                            _avatarID,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Display the user's name
                Text(
                  _name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Display the referral code
                ProfileReferralCode(
                    referralCodeController: _referralCodeController),
                Spacer(),
                // Display configuration options
                ProfileConfigureScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}
