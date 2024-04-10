import 'package:flutter/material.dart';
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


  String name = '';
  String error ='';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);

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


                    dynamic result = null;


                    if(result == null){
                      setState(() {
                        loading = false;
                        error = 'Login unsuccessful';
                      });
                    
                  }
                },
                child: const Text(
                  'Join',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}