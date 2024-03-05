import 'package:flutter/material.dart';
import 'package:farm_expense_mangement_app/frontend/profilepage.dart';

class HomePage extends StatefulWidget {
  final int totalCows;
  final int milkingCows;
  final int dryCows;
  final double avgMilkPerCow;

  const HomePage({
    super.key,
    required this.totalCows,
    required this.avgMilkPerCow,
    required this.dryCows,
    required this.milkingCows,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Color totalCowsColor = Color.fromRGBO(224, 191, 184, 1.0); // Green color
    Color milkingCowsColor = Color.fromRGBO(252, 222, 172, 1.0); // Red color
    Color dryCowsColor = Color.fromRGBO(88, 148, 120, 1.0); // Blue color
    Color avgMilkPerCowColor = Color.fromRGBO(202,217,173, 1.0); // Yellow color
    Color mycolor = Color(0xFF39445A);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
            'Dairy Management App',
          style: TextStyle(
            color: Colors.white
          ),

        ),
        backgroundColor: mycolor,
        // Setting color for the app bar
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {},
          ),
          const SizedBox(width: 16),

        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: buildClickableContainer(
                      context,
                      'Cattles',
                      'asset/cattles.jpg',
                      // 'https://static.vecteezy.com/system/resources/previews/014/568/676/original/milk-cow-icon-simple-style-vector.jpg',
                     totalCowsColor, // Setting color for this container
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AnimalPage()),
                      ) as String,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildClickableContainer(
                      context,
                      'Feed',
                      'asset/feed.jpg',
                      // 'https://thumbs.dreamstime.com/b/feeding-cow-stylized-vector-feeding-cow-stylized-vector-silhouette-103872165.jpg',
                      milkingCowsColor, // Setting color for this container
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MilkingCowsPage()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: buildClickableContainer(
                      context,
                      'Transactions',
                      'asset/transactions.webp',
                      // 'https://thumbs.dreamstime.com/b/finance-management-linear-icons-data-analysis-symbol-template-graphic-web-design-collection-logo-icon-263711792.jpg',
                      dryCowsColor, // Setting color for this container
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DryCowsPage()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildClickableContainer(
                      context,
                      'Avg Milk/Cow',
                      'asset/avg.jpg',
                      // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA1NYO1taWsdYChV36YpskudbNaYMbzIf3Jw&usqp=CAU',
                      avgMilkPerCowColor, // Setting color for this container
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AvgMilkCowPage()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
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

  GestureDetector buildClickableContainer(
      BuildContext context,
      String value,
      String imageUrl,
      Color containerColor,
      Function() onTap,
      ) {
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
                      style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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

class AnimalPage extends StatelessWidget {
  const AnimalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal'),
      ),
      body: Center(
        child: const Text('Animal Page'),
      ),
    );
  }
}

class MilkingCowsPage extends StatelessWidget {
  const MilkingCowsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milking Cows'),
      ),
      body: Center(
        child: const Text('Milking Cows Page'),
      ),
    );
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
      body: Center(
        child: const Text('Dry Cows Page'),
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
      body: Center(
        child: const Text('Avg Milk/Cow Page'),
      ),
    );
  }
}
