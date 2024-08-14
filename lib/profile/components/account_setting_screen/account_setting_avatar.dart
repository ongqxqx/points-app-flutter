import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class AccountSettingAvatar extends StatefulWidget {
  final String? avatarID;
  final Function(String) onAvatarSelected;

  const AccountSettingAvatar({
    Key? key,
    required this.avatarID,
    required this.onAvatarSelected,
  }) : super(key: key);

  @override
  _AccountSettingAvatarState createState() => _AccountSettingAvatarState();
}

class _AccountSettingAvatarState extends State<AccountSettingAvatar> {
  String? _avatarID;
  String? _selectedAvatarID;
  List<String> _avatarList = [];

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();

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
          _avatarID = data['avatarID'];
        });
      }
    }
  }

  List<String> generateRandomAvatarList(int count) {
    Random random = Random();
    List<String> avatarList = [];
    for (int i = 0; i < count; i++) {
      int randomNumber = random.nextInt(1000);
      String avatarID = 'avatar_$randomNumber';
      avatarList.add(avatarID);
    }
    return avatarList;
  }

  void _showAvatarSelectionDialog() {
    setState(() {
      _avatarList = generateRandomAvatarList(12);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Avatar'),
              content: _buildAvatarGrid(setState),
              actions: <Widget>[
                TextButton(
                  child: const Text('Regenerate'),
                  onPressed: () {
                    setState(() {
                      _avatarList = generateRandomAvatarList(12);
                    });
                  },
                ),
                TextButton(
                  child: const Text('Close'),
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
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _avatarList.length,
        itemBuilder: (BuildContext context, int index) {
          String avatarID = _avatarList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAvatarID = avatarID;
                print('Avatar selected: $_selectedAvatarID');
              });
              widget.onAvatarSelected(_selectedAvatarID!);
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor:
              _selectedAvatarID == avatarID ? Colors.blue : Colors.grey,
              child: ClipOval(
                child: RandomAvatar(avatarID, width: 100, height: 100),
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
        onTap: _showAvatarSelectionDialog,
        child: CircleAvatar(
          radius: 50,
          child: ClipOval(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: RandomAvatar(
                _selectedAvatarID ?? _avatarID ?? DateTime.now().millisecondsSinceEpoch.toString(),
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
