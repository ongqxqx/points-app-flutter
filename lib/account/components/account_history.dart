import 'package:flutter/material.dart';

class AccountHistory extends StatelessWidget {
  const AccountHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: const Center(
        child: Text('This is history page'),
      ),
    );
  }
}
