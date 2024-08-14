import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/home/components/home_my_reward_screen.dart';

class HomeMyReward extends StatelessWidget {
  const HomeMyReward({Key? key}) : super(key: key);

  Future<int> _getRewardCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 0; // 如果没有用户，则返回0
    }

    if (user.isAnonymous) {
      return -1; // 匿名用户时返回特殊值
    }

    final rewardsSnapshot = await FirebaseFirestore.instance
        .collection('user_reward')
        .doc(user.uid)
        .get();

    if (rewardsSnapshot.exists) {
      final rewardsData = rewardsSnapshot.data();
      if (rewardsData != null) {
        return rewardsData.keys.length;
      }
    }
    return 0; // 如果没有奖励数据，则返回0
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeMyRewardScreen(),
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
              'myRewards'.tr,
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FutureBuilder<int>(
                  future: _getRewardCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }
                    if (snapshot.data == -1) {
                      return Text(
                        '--',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }
                    return Text(
                      snapshot.data?.toString() ?? '0',
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
