


import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.black)
            ),
            onPressed: () {
            },
            icon: const Icon(Icons.person),
            label: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.black
              )
            ),
          )
        ],
        backgroundColor: Colors.purple[200],
        elevation: 0.0,
        title: const Text('Register'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                validator:(value) => value!.isEmpty ? 'Enter an email' : null,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                validator: (value) => value!.length < 6 ? 'Enter a password 6+ characters long' : null,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: true,
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                validator: (value) => value != password ? 'Passwords must match' : null,
                onChanged: (value) {
                  confirmPassword = value;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple[300])),
                onPressed: () {

                  if(_formKey.currentState!.validate()){

                  }
                  setState(() {
                    error = 'Sign in unsuccessful';
                  });
                },
                child: const Text(
                  'Sign In',
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