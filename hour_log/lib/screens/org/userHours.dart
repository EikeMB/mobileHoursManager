import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/services/auth.dart';

class UserHours extends StatefulWidget {
  final Organization org;
  final UserData user;
  const UserHours(this.org, this.user, {super.key});

  @override
  State<UserHours> createState() => _UserHoursState();
}

class _UserHoursState extends State<UserHours> {

  DateTime? selectedFirstDate;
  DateTime? selectedSecondDate;

  Future<void> _pickFirstDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedFirstDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedFirstDate) {
      setState(() {
        selectedFirstDate = pickedDate;
      });

    }
  }

  Future<void> _pickSecondDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedSecondDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedSecondDate) {
      setState(() {
        selectedSecondDate = pickedDate;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    UserData user = widget.user;
    Organization org = widget.org;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.black)
            ),
            icon: const Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
            label: const Text(
              'logout',
              style: TextStyle(
                color: Colors.black
              )
            ),
          )
        ],
        title: const Text('User'),
      ),
      body: Text('userDetails'),
    );
  }
}