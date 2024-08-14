import 'package:flutter/material.dart';

class AccountSettingUid extends StatelessWidget {
  final TextEditingController uidController;

  const AccountSettingUid({
    Key? key,
    required this.uidController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //obscureText: true,
      controller: uidController,
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: 'UID'),
      readOnly: true,
    );
  }
}
