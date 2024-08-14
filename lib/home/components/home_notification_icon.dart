import 'package:flutter/material.dart';
import 'package:points/account/account_notification_screen.dart';

class HomeNotificationIcon extends StatelessWidget {
  const HomeNotificationIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications_none,color: Color(0xFFF26101),),
      onPressed: () {
        // 在点击时导航到通知列表页面
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountNotificationScreen()),
        );
      },
    );
  }
}
