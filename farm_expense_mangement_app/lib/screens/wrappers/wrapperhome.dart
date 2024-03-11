import 'dart:async';

import 'package:farm_expense_mangement_app/screens/home/homepage.dart';
import 'package:farm_expense_mangement_app/screens/home/profilepage.dart';
import 'package:flutter/material.dart';

import '../../models/cattle.dart';
import '../../models/user.dart';

final listCattle = [
  Cattle(
    rfid: "5515154",
    sex: "female",
    age: 10,
    breed: "cow",
    lactationCycle: 2,
    weight: 120, /*dateOfBirth: DateTime.parse('2020-12-01')*/
  )
];

final farmUser = FarmUser(
    ownerName: "sushil",
    farmName: "sushil dairy",
    location: "chandigarh",
    phoneNo: 8053004565);

class WrapperHomePage extends StatefulWidget {
  const WrapperHomePage({super.key});

  @override
  State<WrapperHomePage> createState() => _WrapperHomePageState();
}

class _WrapperHomePageState extends State<WrapperHomePage> {
  late StreamController<int> _streamControllerScreen;
  final int _screenFromNumber = 0;

  late PreferredSizeWidget _appBar;
  late PreferredSizeWidget _bodyScreen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamControllerScreen = StreamController<int>.broadcast();
    _streamControllerScreen.add(_screenFromNumber);
    _appBar = const HomeAppBar();
    _bodyScreen = const HomePage() as PreferredSizeWidget;
  }

  void home(BuildContext context) {
    setState(() {
      _appBar = const HomeAppBar();
      _bodyScreen = const HomePage() as PreferredSizeWidget;
    });
  }

  void profile(BuildContext context) {
    //TODO: [FUNCTION FOR BOTTOM PROFILE BUTTON]
    setState(() {
      _appBar = const ProfileAppBar();
      _bodyScreen = const ProfilePage() as PreferredSizeWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar,
      body: _bodyScreen,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                home(context);
              },
              iconSize: 32,
            ),
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {},
              iconSize: 32,
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                ///BOTTOM BOTTOM TODO:[PROFILE]
                profile(context);
              },
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
    );
  }

  GestureDetector buildClickableContainer({
    required BuildContext context,
    required String value,
    required String imageUrl,
    required Color containerColor,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: containerColor, // Using the color passed from the parent
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.only(bottom: 40, right: 20),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ClipOval(
                child: Image.asset(
                  imageUrl,
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 25,
              left: 20,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DryCowsPage extends StatelessWidget {
  const DryCowsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dry Cows'),
      ),
      body: const Center(
        child: Text('Dry Cows Page'),
      ),
    );
  }
}

class AvgMilkCowPage extends StatelessWidget {
  const AvgMilkCowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avg Milk/Cow'),
      ),
      body: const Center(
        child: Text('Avg Milk/Cow Page'),
      ),
    );
  }
}
