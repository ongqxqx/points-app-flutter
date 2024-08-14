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
  bool get wantKeepAlive => true;

  Future<void> _refresh() async {
    // 在这里添加你的刷新逻辑
    await Future.delayed(Duration(seconds: 1)); // 模拟网络请求延迟
    Get.forceAppUpdate();  // 这将强制应用程序的所有页面刷新
    // BottomNavigationScreen.mainPageKey.currentState?.setState(() {
    //   BottomNavigationScreen.mainPageKey.currentState?.updateCurrentPage(HomeScreen());
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以确保自动保持活动功能正常工作

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        color: Color(0xFFFFFF)),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // 使下拉刷新生效
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 30.0, // Set the desired height here
                    child: Row(
                      children: [
                        HomeAvatar(),
                        SizedBox(width: 10.0),
                        HomeUserName(),
                        Spacer(), // Add Spacer to push HomeNotificationIcon to the right
                        HomeNotificationIcon(),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      HomeAccountHistory(),
                    ],
                  ),
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
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Text(
                        'Rewards'.tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF26101), // Ensure the text is visible on dark background
                        ),
                      ),
                      Spacer(),
                      HomeRewardViewAll(),
                    ],
                  ),
                  HomeProductList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
