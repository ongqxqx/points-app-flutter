import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountNotificationScreen extends StatelessWidget {
  const AccountNotificationScreen({Key? key}) : super(key: key);

  Future<List<Map<String, String>>> _fetchNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final userNotifyDoc = await FirebaseFirestore.instance
          .collection('user_notify')
          .doc(user.uid)
          .get();

      if (userNotifyDoc.exists) {
        final data = userNotifyDoc.data() as Map<String, dynamic>?;

        if (data == null) {
          print('Data is null');
          return [];
        }

        final notifications = data.entries.map((entry) {
          final timestamp = entry.key;
          final content = entry.value.toString();

          return {
            'timestamp': timestamp,
            'content': content,
          };
        }).toList();

        notifications.sort((a, b) => b['timestamp']!.compareTo(a['timestamp']!));

        return notifications;
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
    return [];
  }

  DateTime _parseTimestamp(String timestamp) {
    return DateTime(
      int.parse(timestamp.substring(0, 4)),  // Year
      int.parse(timestamp.substring(4, 6)),  // Month
      int.parse(timestamp.substring(6, 8)),  // Day
      int.parse(timestamp.substring(8, 10)), // Hour
      int.parse(timestamp.substring(10, 12)), // Minute
      int.parse(timestamp.substring(12, 14)), // Second
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final content = notification['content'] ?? 'No content';
              final timestamp = notification['timestamp'];
              final formattedDate = timestamp != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(
                  _parseTimestamp(timestamp))
                  : 'Unknown date';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(content),
                  subtitle: Text(formattedDate),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
