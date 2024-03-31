import 'package:flutter/material.dart';
import 'package:farm_expense_mangement_app/services/auth.dart';
import 'package:farm_expense_mangement_app/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Color myColor = const Color(0xff39445a);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent, // Set background color to transparent
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'asset/f3.jpeg', // Change the path to your image
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Absolute Positioned AppBar
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0, // Remove the shadow

                  actions: <Widget>[
                    TextButton.icon(
                      icon: const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () => widget.toggleView(),
                    ),
                  ],
                ),
                // Form Content
                Padding(
                  padding: const EdgeInsets.all(20.0), // Add padding
                  child: Container(
                    width: 300, // Adjust width as needed
                    decoration: BoxDecoration(
                      // color: Colors.black.withOpacity(0.3), // Set the color with opacity
                      borderRadius: BorderRadius.circular(10), // Set border radius
                      // border: Border.all(color: Colors.black), // Add border
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // Add padding
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(hintText: 'email'),
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(hintText: 'password'),
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[900], // Set the button's background color
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  dynamic result =
                                  await _auth.signInWithEmailAndPassword(email, password);
                                  if (result == null) {
                                    setState(() {
                                      error = 'Could not sign in with those credentials';
                                    });
                                  }
                                }
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
