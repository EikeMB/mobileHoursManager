import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/shared/constants.dart';
import 'package:hour_log/shared/loading.dart';
import 'package:provider/provider.dart';

class ChangeUserName extends StatefulWidget {
  const ChangeUserName({super.key});

  @override
  State<ChangeUserName> createState() => _ChangeUserNameState();
}

class _ChangeUserNameState extends State<ChangeUserName> {

  final _formKey = GlobalKey<FormState>();

  bool loading = false;


  String name = '';
  String error ='';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    final orgs = Provider.of<List<Organization>?>(context);
    return loading ? const Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        
        title: const Text('Change Username'),
      ),
      body: user != null ? Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Username'),
                validator:(value) => value!.isEmpty ? 'Enter a new username' : null,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple[300])),
                onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                    }

                    dynamic result = await databaseService!.updateUserData(name, user.orgs, user.workDays);
                    dynamic resultOrg;
                    if(orgs != null){
                      for(Organization org in orgs){
                        if(org.owner.uid == user.uid){
                          resultOrg = await databaseService!.updateOrganizationData(org.name, org.code, org.members, UserData(user.uid, name, user.orgs, user.workDays));

                        }
                        else{
                          List<UserData> members = [];
                          for(UserData member in org.members){
                            if(member.uid == user.uid){
                              members.add(UserData(member.uid, name, member.orgs, member.workDays));
                            }
                            else{
                              members.add(member);
                            }
                          }
                          resultOrg = await databaseService!.updateOrganizationData(org.name, org.code, members, org.owner);
                        }
                      }
                    }
                    
                    if(result == null || resultOrg == null){
                      setState(() {
                        loading = false;
                        error = 'Username update unsuccessful';
                      });
                    
                    }

                    Navigator.pop(context);
                },
                child: const Text(
                  'Change',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0,),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14.0
                ),
              )
            ],
          ),
        ),
      ) : null,
    );
  }
}