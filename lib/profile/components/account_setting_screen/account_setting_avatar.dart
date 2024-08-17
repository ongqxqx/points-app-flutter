import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class AccountSettingAvatar extends StatefulWidget {
  final String? avatarID; // Initial avatar ID to display
  final Function(String) onAvatarSelected; // Callback for when an avatar is selected

  const AccountSettingAvatar({
    Key? key,
    required this.avatarID,
    required this.onAvatarSelected,
  }) : super(key: key);

  @override
  _AccountSettingAvatarState createState() => _AccountSettingAvatarState();
}

class _AccountSettingAvatarState extends State<AccountSettingAvatar> {
  String? _avatarID; // Current avatar ID from Firestore
  String? _selectedAvatarID; // Avatar ID selected by the user
  List<String> _avatarList = []; // List of generated avatar IDs

  @override
  void initState() {
    super.initState();
    _loadUserAvatar(); // Load the user's avatar on initialization
  }

  Future<void> _loadUserAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _avatarID = data['avatarID']; // Update state with the loaded avatar ID
        });
      }
    }
  }

  List<String> generateRandomAvatarList(int count) {
    Random random = Random();
    List<String> avatarList = [];
    for (int i = 0; i < count; i++) {
      int randomNumber = random.nextInt(1000);
      String avatarID = 'avatar_$randomNumber'; // Generate a random avatar ID
      avatarList.add(avatarID);
    }
    return avatarList;
  }

  void _showAvatarSelectionDialog() {
    setState(() {
      _avatarList = generateRandomAvatarList(12); // Generate a new list of avatars
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Avatar'),
              content: _buildAvatarGrid(setState), // Build the avatar grid
              actions: <Widget>[
                TextButton(
                  child: const Text('Regenerate'), // Button to regenerate avatars
                  onPressed: () {
                    setState(() {
                      _avatarList = generateRandomAvatarList(12); // Regenerate the avatar list
                    });
                  },
                ),
                TextButton(
                  child: const Text('Close'), // Button to close the dialog
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAvatarGrid(StateSetter setState) {
    return Container(
      width: double.maxFinite,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
        ),
        itemCount: _avatarList.length, // Number of avatars in the grid
        itemBuilder: (BuildContext context, int index) {
          String avatarID = _avatarList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAvatarID = avatarID; // Update selected avatar ID
                print('Avatar selected: $_selectedAvatarID');
              });
              widget.onAvatarSelected(_selectedAvatarID!); // Notify parent widget of the selected avatar
              Navigator.of(context).pop(); // Close the dialog
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor:
              _selectedAvatarID == avatarID ? Colors.blue : Colors.grey, // Highlight selected avatar
              child: ClipOval(
                child: RandomAvatar(avatarID, width: 100, height: 100), // Display the avatar
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _showAvatarSelectionDialog, // Show the avatar selection dialog on tap
        child: CircleAvatar(
          radius: 50,
          child: ClipOval(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey, // Default background color for the avatar
                shape: BoxShape.circle,
              ),
              child: RandomAvatar(
                _selectedAvatarID ?? _avatarID ?? DateTime.now().millisecondsSinceEpoch.toString(), // Display selected or default avatar
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
