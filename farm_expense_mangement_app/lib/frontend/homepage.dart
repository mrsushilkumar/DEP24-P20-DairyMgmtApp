
import 'package:farm_expense_mangement_app/frontend/elements.dart';
import 'package:farm_expense_mangement_app/frontend/profilepage.dart';
import 'package:flutter/material.dart';

import '../backend/cattle.dart';

final cattle = Cattle("5515154", "female", 10,"cow" , 2, 120);

class HomePage extends StatelessWidget {
  // Variables to store data
  final int totalCows;
  final int milkingCows;
  final int dryCows ;
  final double avgMilkPerCow ;

  const HomePage({
    super.key,
    required this.totalCows,
    required this.avgMilkPerCow,
    required this.dryCows,
    required this.milkingCows
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[800],
        appBar: AppBar(
          title: const Text('Dairy Management App'),
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.white,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.square_foot),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnimalDetails(cattle: cattle)),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
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
                                child: Image.network(
                                  'https://static.vecteezy.com/system/resources/previews/014/568/676/original/milk-cow-icon-simple-style-vector.jpg',
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.width * 0.25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$totalCows',
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Total Cows',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
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
                                child: Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkACQ9JqhZDhy2y5BXcYleShaiMksW1viSoA&usqp=CAU',
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.width * 0.25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$milkingCows',
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Milking Cows',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnimalDetails(cattle: cattle)),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
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
                                child: Image.network(
                                  'https://as1.ftcdn.net/v2/jpg/02/92/08/34/1000_F_292083443_imWPeOvx31RTSuUuMod3tcDvL0nUBlkj.jpg',
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.width * 0.25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$dryCows',
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Dry Cows',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
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
                                child: Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA1NYO1taWsdYChV36YpskudbNaYMbzIf3Jw&usqp=CAU',
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.width * 0.25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$avgMilkPerCow',
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Avg Milk/Cow',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
                iconSize: 32, // Increase icon size
              ),
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {},
                iconSize: 32, // Increase icon size
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                iconSize: 32, // Increase icon size
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
                iconSize: 32, // Increase icon size
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.75, size.width * 0.75, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
