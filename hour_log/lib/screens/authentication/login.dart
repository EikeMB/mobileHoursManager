

import 'package:flutter/material.dart';

class SignIn extends StatefulWidget{
  final Function toggleView;
  
  const SignIn(this.toggleView, {super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.black)
            ),
            onPressed: () {
              widget.toggleView();
            },
            icon: const Icon(Icons.person),
            label: const Text(
              'Register',
              style: TextStyle(
                color: Colors.black
              )
            ),
          )
        ],
        backgroundColor: Colors.purple[200],
        elevation: 0.0,
        title: const Text('Sign in'),
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
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple[300])),
                onPressed: () {
                  setState(() {
                    if(_formKey.currentState!.validate()){

                    }

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