import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign-In'),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  TextFormField(
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
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
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
                  Center(
                    child: RaisedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          var email = emailController.text.trim();
                          var password = passwordController.text.trim();
                          signIn(email, password)
                              .then((AuthResult result) => Navigator.of(context)
                                  .pushNamed('/vote', arguments: result))
                              .catchError((e) => {
                                    if (e
                                            .toString()
                                            .contains("ERROR_USER_NOT_FOUND") ||
                                        e
                                            .toString()
                                            .contains("ERROR_WRONG_PASSWORD"))
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return _buildAuthFailedDialog(
                                                "Invalid email or password");
                                          },
                                        )
                                      }
                                    else
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return _buildAuthFailedDialog(
                                                "Un expected error occurred");
                                          },
                                        )
                                      }
                                  });
                        }
                      },
                    ),
                  ),
                  Center(
                    child: RaisedButton(
                      child: const Text('Sign-In with Google'),
                      onPressed: () {
                        print("Google");
                        signInWithGoogle(context)
                            .then((AuthResult result) => Navigator.of(context)
                                .pushNamed('/vote', arguments: result))
                            .catchError((e) => {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return _buildAuthFailedDialog(
                                          "Google Sign-In failed");
                                    },
                                  )
                                });
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

Widget _buildAuthFailedDialog(String message) {
  return AlertDialog(
    title: Center(child: Text("Failed to Sign-In")),
    content: SingleChildScrollView(
      child: Text(message),
    ),
  );
}

Future<AuthResult> signIn(String email, String password) async {
  final _firebaseAuth = FirebaseAuth.instance;
  final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password);
  return result;
}

Future<AuthResult> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  AuthResult result =
      await FirebaseAuth.instance.signInWithCredential(credential);
  return result;
}
