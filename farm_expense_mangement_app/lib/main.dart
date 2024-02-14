import 'package:farm_expense_mangement_app/firebase_options.dart';
import 'package:farm_expense_mangement_app/frontend/elements.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final List<String> listCattle = List.of({"Cattle 1","Cattle 2","Cattle 3"});

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CattleView(listCattle: listCattle);
  }
}


