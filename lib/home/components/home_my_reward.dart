import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/home/components/home_my_reward_screen.dart';

class HomeMyReward extends StatelessWidget {
  const HomeMyReward({Key? key}) : super(key: key);

  // Asynchronously fetch the count of rewards for the current user
  Future<int> _getRewardCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 0; // Return 0 if no user is logged in
    }

    if (user.isAnonymous) {
      return -1; // Return special value for anonymous users
    }

    final rewardsSnapshot = await FirebaseFirestore.instance
        .collection('user_reward')
        .doc(user.uid)
        .get();

    if (rewardsSnapshot.exists) {
      final rewardsData = rewardsSnapshot.data();
      if (rewardsData != null) {
        return rewardsData.keys.length; // Count the number of rewards
      }
    }
    return 0; // Return 0 if no rewards data exists
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeMyRewardScreen(), // Navigate to HomeMyRewardScreen on tap
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 100,
        margin: const EdgeInsets.only(left: 5),
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
              'myRewards'.tr, // Display the translated 'myRewards' text
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FutureBuilder<int>(
                  future: _getRewardCount(), // Fetch reward count asynchronously
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: Colors.white, // Show a loading indicator while fetching data
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error', // Display an error message if there's an issue
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }
                    if (snapshot.data == -1) {
                      return Text(
                        '--', // Display '--' for anonymous users
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }
                    return Text(
                      snapshot.data?.toString() ?? '0', // Display reward count or default to '0'
                      style: TextStyle(
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
      ),
    );
  }
}
