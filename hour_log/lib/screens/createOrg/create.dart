import 'package:flutter/material.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/shared/constants.dart';
import 'package:hour_log/shared/loading.dart';
import 'package:provider/provider.dart';

class CreateOrg extends StatefulWidget {
  const CreateOrg({super.key});

  @override
  State<CreateOrg> createState() => _CreateOrgState();
}

class _CreateOrgState extends State<CreateOrg> {

  final _formKey = GlobalKey<FormState>();

  bool loading = false;


  String name = '';
  String error ='';

  

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserData?>(context);

    return loading ? const Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        
        title: const Text('Create Org'),
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
                decoration: textInputDecoration.copyWith(hintText: 'Organization Name'),
                validator:(value) => value!.isEmpty ? 'Enter a name for the organization' : null,
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

                    String code = generateRandomString(4);

                    List<UserData> members = [];
                    UserData owner = user!;
                    dynamic result = await databaseService!.updateOrganizationData(name, code, members, owner);
                    user.orgs.add(code);
                    dynamic resultUser = await databaseService!.updateUserData(user.username, user.orgs, user.workDays);
                    
                    if(result == null || resultUser != null){
                      setState(() {
                        loading = false;
                        error = 'Create unsuccessful';
                      });
                    
                    }

                    Navigator.pop(context);
                },
                child: const Text(
                  'Create',
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