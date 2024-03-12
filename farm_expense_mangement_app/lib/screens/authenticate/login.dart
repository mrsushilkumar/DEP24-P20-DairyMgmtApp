import 'package:farm_expense_mangement_app/services/auth.dart';
import 'package:flutter/material.dart';
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
    Color mycolor=const Color(0xff39445a);
    return MaterialApp( // Wrap with MaterialApp
      home: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: mycolor,
          // elevation: 0.0,
          title: const Text('Dairy Management App',
            style: TextStyle(
              color: Colors.white,
            ),

          ),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person,
                color: Colors.white,
              ),
              label: const Text('Register',
                  style: TextStyle(
                      color: Colors.white
                  )

              ),
              onPressed: () => widget.toggleView(),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
                    backgroundColor: Colors.pink[400], // Set the button's background color
                  ),
                  onPressed: () async {
                    // print(email);
                    // print(password);
                    if(_formKey.currentState!.validate()){
                      // setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      // print(result);
                      if(result == null) {
                        setState(() {
                          // loading = false;
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    }

                    // return Home(),
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
    );
  }
}
