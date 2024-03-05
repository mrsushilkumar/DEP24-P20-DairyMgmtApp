
import 'package:farm_expense_mangement_app/firebase_options.dart';
import 'package:farm_expense_mangement_app/frontend/authentication.dart';
import 'package:farm_expense_mangement_app/frontend/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final List<String> listCattle = List.of({"Cattle 1","Cattle 2","Cattle 3"});

void main() async{


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );


  FirebaseAuth.instance.signInWithEmailAndPassword(email: "2021csb1136@iitrpr.ac.in", password: "iit@123#");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          final user = snapshot.data;
          if(user == null)
            {
              return const LoginPage();
            }
          else
            {
              return const HomePage(totalCows: 2, avgMilkPerCow: 6, dryCows: 1, milkingCows: 1);
            }
        },
      )
    );
  }
}


