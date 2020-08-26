import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySignInPage extends StatefulWidget {
  @override
  _MySignInPageState createState() {
    return _MySignInPageState();
  }
}

class _MySignInPageState extends State<MySignInPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final emailController = new TextEditingController();
    final passwordController = new TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('SignIn'),
        ),
        body: new Center(
          child: new Form(
            key: _formKey,
            child: new SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  new TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                          ? null
                          : "Please Enter Correct Email";
                    },
                  ),
                  const SizedBox(height: 24.0),
                  new TextFormField(
                    controller: passwordController,
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (val) {
                      return val.length > 6
                          ? null
                          : "Enter Password 6+ characters";
                    },
                  ),
                  const SizedBox(height: 24.0),
                  new Center(
                    child: new RaisedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          var email = emailController.text;
                          var password = passwordController.text;
                          // TODO Login HERE
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
