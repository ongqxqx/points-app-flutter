import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/home/components/home_user_name.dart';
import 'package:points/home/components/home_notification_icon.dart';
import 'package:points/navigation/bottom_navigation_screen.dart';
import 'components/home_product_list.dart';
import 'components/home_reward_view_all.dart';
import 'components/home_avatar.dart';
import 'components/home_history.dart';
import 'components/home_my_point.dart';
import 'components/home_my_reward.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true; // Keeps the state of this screen when navigating away

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1)); // Simulates a refresh delay
    Get.forceAppUpdate(); // Forces a rebuild of the app to reflect any updates
    // Uncomment below if using BottomNavigationScreen to update current page
    // BottomNavigationScreen.mainPageKey.currentState?.setState(() {
    //   BottomNavigationScreen.mainPageKey.currentState?.updateCurrentPage(HomeScreen());
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensures the AutomaticKeepAliveClientMixin works

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFF), // Background color for the screen
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh, // Triggers refresh when pulled down
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Ensures scroll behavior
              padding: EdgeInsets.all(16.0), // Padding around the content
              child: Column(
                children: [
                  // Header section with Avatar, UserName, and Notification Icon
                  Container(
                    height: 35.0, // Set the desired height for the header
                    child: Row(
                      children: [
                        HomeAvatar(),
                        SizedBox(width: 10.0), // Spacing between avatar and username
                        HomeUserName(),
                        Spacer(), // Pushes notification icon to the far right
                        HomeNotificationIcon(),
                      ],
                    ),
                  ),
                  // History and Account section
                  Row(
                    children: [
                      Spacer(),
                      HomeAccountHistory(),
                    ],
                  ),
                  // Points and Reward section
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: HomeMyPoint(),
                      ),
                      Expanded(
                        flex: 1,
                        child: HomeMyReward(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0), // Spacing between sections
                  // Rewards heading and View All button
                  Row(
                    children: [
                      Text(
                        'Rewards'.tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF26101), // Text color for visibility
                        ),
                      ),
                      Spacer(),
                      HomeRewardViewAll(),
                    ],
                  ),
                  HomeProductList(), // List of products
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
