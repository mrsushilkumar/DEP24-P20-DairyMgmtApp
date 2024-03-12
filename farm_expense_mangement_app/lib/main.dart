import 'package:farm_expense_mangement_app/firebase_options.dart';
import 'package:farm_expense_mangement_app/screens/authenticate/authentication.dart';
import 'package:farm_expense_mangement_app/screens/wrappers/wrapperhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


// final List<String> listCattle = List.of({"Cattle 1","Cattle 2","Cattle 3"});
// final cattle = Cattle(rfid:"5515154",sex:  "male",age:  10,breed: "goat" ,lactationCycle:  3,weight:  120/*,dateOfBirth: DateTime.parse('2020-12-01')*/);

// final farmUser = FarmUser(ownerName: "sushil",farmName:  "sushil dairy",address:  "chandigarh");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FirebaseAuth.instance.createUserWithEmailAndPassword(email: '2021csb1136@iitrpr.ac.in', password: 'iit@123#');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return const Authenticate();
        } else {
          // final cattleDb = DatabaseServicesForCattle(user.uid);

          // cattleDb.infoToServerSingleCattle(cattle);
          return const WrapperHomePage();
        }
      },
    ));
  }
}
