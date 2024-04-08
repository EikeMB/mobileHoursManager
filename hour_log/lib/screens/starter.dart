import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/createOrg/create.dart';
import 'package:hour_log/screens/home/home.dart';
import 'package:hour_log/screens/profile/profile.dart';
import 'package:hour_log/shared/constants.dart';
import 'package:provider/provider.dart';

class Starter extends StatefulWidget {
  const Starter({super.key});
  
  @override
  State<Starter> createState() => _StarterState();
}

class _StarterState extends State<Starter> {


  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    createDatabaseService(user!.uid);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home', selectedIcon: Icon(Icons.home_filled)),
          NavigationDestination(icon: Icon(Icons.add), label: 'Create Org', selectedIcon: Icon(Icons.add_outlined)),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile', selectedIcon: Icon(Icons.person)),
        ],
        indicatorColor: Colors.purple[100],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: <Widget>[
        StreamProvider<List<Organization>?>.value(value: databaseService!.orgs, initialData: null, child: const Home(),),
        StreamProvider<UserData?>.value(initialData: null, value: databaseService!.userData, child: const CreateOrg(),),
        const Profile()
      ][_selectedIndex],
    );
  }
}