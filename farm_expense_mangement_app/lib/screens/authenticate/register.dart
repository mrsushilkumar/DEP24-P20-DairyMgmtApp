
import 'package:farm_expense_mangement_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:farm_expense_mangement_app/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key,  required this.toggleView });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  final TextEditingController _textController = TextEditingController();


  // Text field state
  String email = '';
  String password = '';
  String ownerName = '';
  String farmName = '';
  String location= '';
  int phoneNo=1234567;


  @override
  Widget build(BuildContext context) {
    Color myColor=const Color(0xff39445a);
    return MaterialApp( // Wrap with MaterialApp
      home: Scaffold(
        backgroundColor: Colors.brown[100],

        appBar: AppBar(
          backgroundColor: myColor,

          // elevation: 0.0,
          title: const Text('Dairy Management App',
            style: TextStyle(
              // backgroundColor: Colors.whiCol
                color: Colors.white
            ),),
          // actions: <Widget>[],
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person,
                color: Colors.white,
              ),
              label: const Text('Sign In',
                style: TextStyle(
                    color: Colors.white
                ),

              ),
              onPressed: () => widget.toggleView(),
            ),
          ],
        ),

        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'email'),

                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(hintText: 'password'),

                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 20.0),

                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Owner_name'),

                  // validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => ownerName = val);
                  },
                ),
                const SizedBox(height: 20.0),

                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Farm_name'),

                  // validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => farmName = val);
                  },
                ),
                const SizedBox(height: 20.0),

                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Location'),

                  // validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => location = val);
                  },
                ),
                const SizedBox(height: 20.0),

                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Phone_no'),
                    keyboardType: TextInputType.number,
                  controller: _textController

                  // validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  // onChanged: (val) {
                  //   setState(() => phoneNo = ${val});
                  // },
                ),

                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                  ),
                  onPressed: () async {
                    // print(email);
                    // print(password);
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password,ownerName,farmName,location,phoneNo);
                      // print(result);
                      if (result == null) {
                        setState(() {
                          error = 'Please supply a valid email';
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
