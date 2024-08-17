import 'package:flutter/material.dart';

class AccountHistory extends StatelessWidget {
  const AccountHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Creates a Scaffold structure, which is a Material Design layout that includes an AppBar and a body.
    return Scaffold(
      appBar: AppBar(
        // Displays the title "History" in the AppBar.
        title: const Text('History'),
      ),
      body: const Center(
        // Centers and displays the text "This is history page" in the body section.
        child: Text('This is history page'),
      ),
    );
  }
}
