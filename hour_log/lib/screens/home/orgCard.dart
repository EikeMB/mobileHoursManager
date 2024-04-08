import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';

class OrgCard extends StatefulWidget {
  Organization org;
  OrgCard(this.org, {super.key});

  @override
  State<OrgCard> createState() => _OrgCardState();
}

class _OrgCardState extends State<OrgCard> {
  @override
  Widget build(BuildContext context) {
    return Card(child: Text(widget.org.name),);
  }
}