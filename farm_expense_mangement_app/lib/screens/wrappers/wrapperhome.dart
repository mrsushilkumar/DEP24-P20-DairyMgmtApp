import 'dart:async';

import 'package:farm_expense_mangement_app/screens/home/homepage.dart';
import 'package:farm_expense_mangement_app/screens/home/profilepage.dart';
import 'package:flutter/material.dart';

class WrapperHomePage extends StatefulWidget {
  const WrapperHomePage({Key? key});

  @override
  State<WrapperHomePage> createState() => _WrapperHomePageState();
}

class _WrapperHomePageState extends State<WrapperHomePage> {
  late StreamController<int> _streamControllerScreen;
  final int _screenFromNumber = 0;
  int _selectedIndex = 0; // Add this variable to track selected index

  late PreferredSizeWidget _appBar;
  late PreferredSizeWidget _bodyScreen;

  @override
  void dispose() {
    _streamControllerScreen.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamControllerScreen = StreamController<int>.broadcast();
    _streamControllerScreen.add(_screenFromNumber);
    _appBar = const HomeAppBar();
    _bodyScreen = const HomePage() as PreferredSizeWidget;
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void home(BuildContext context) {
    setState(() {
      _updateIndex(0); // Update index when home is pressed
      _appBar = const HomeAppBar();
      _bodyScreen = const HomePage() as PreferredSizeWidget;
    });
  }

  void profile(BuildContext context) {
    setState(() {
      _updateIndex(1); // Update index when profile is pressed
      _appBar = const ProfileAppBar();
      _bodyScreen = const ProfilePage() as PreferredSizeWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: _appBar,
      body: _bodyScreen,
      bottomNavigationBar: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        child: BottomAppBar(
          color: const Color.fromRGBO(13, 166, 186, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {},
                iconSize: 32,
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  profile(context);
                },
                iconSize: 32,
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    home(context);
                  },
                  backgroundColor: Colors.black,
                  elevation: 0,
                  child: const Icon(Icons.home, color: Colors.white70,),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
                iconSize: 32,
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
                iconSize: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
