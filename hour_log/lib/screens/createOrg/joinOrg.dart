import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/services/auth.dart';
import 'package:hour_log/shared/constants.dart';
import 'package:hour_log/shared/loading.dart';
import 'package:provider/provider.dart';

class JoinOrg extends StatefulWidget {
  const JoinOrg({super.key});

  @override
  State<JoinOrg> createState() => _JoinOrgState();
}

class _JoinOrgState extends State<JoinOrg> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;


  String code = '';
  String error ='';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    final orgs = Provider.of<List<Organization>?>(context);
    return loading ? const Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        
        title: const Text('Join Org'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Organization Code'),
                validator:(value) => value!.isEmpty ? 'Enter the code for the organization' : null,
                onChanged: (value) {
                  setState(() {
                    code = value;
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
                    Organization? org;

                    for(Organization orgCheck in orgs!){
                      if(orgCheck.code == code){
                        org = orgCheck;
                        break;
                      }
                    }

                    if(org != null){
                      bool alreadyIn = false;
                      if(org.owner.uid == user!.uid){
                        alreadyIn = true;
                      }
                      for(UserData member in org.members){
                        if(member.uid == user.uid){
                          alreadyIn = true;
                          
                          break;
                        }
                      }

                      if(!alreadyIn){
                        user.orgs.add(org.code);

                        org.members.add(user);

                        dynamic resultUser = databaseService!.updateUserData(user.username, user.orgs, user.workDays);

                        dynamic resultOrg = databaseService!.updateOrganizationData(org.name, code, org.members, org.owner);

                        if(resultOrg == null){
                          setState(() {
                          loading = false;
                          error = 'Adding org unsuccessful';
                          });
                        }
                        if(resultUser == null){
                          setState(() {
                          loading = false;
                          error = 'Adding org to user unsuccessful';
                          });
                        } 
                      }
                      else{
                        setState(() {
                          loading = false;
                          error = 'Already in the org';
                          });
                      }
                      
                    }
                    else{
                      setState(() {
                        loading = false;
                        error = 'Org does not exist';
                      });
                    }

                    

                    if(error == ''){
                      Navigator.pop(context);
                    }
                  
                                },
                child: const Text(
                  'Join',
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
      ),
    );
  }
}