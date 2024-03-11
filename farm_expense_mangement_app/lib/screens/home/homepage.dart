import 'package:farm_expense_mangement_app/screens/home/animallist.dart';
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
  ),
  Cattle(
    rfid: '12345',
    breed: 'cow', /* dateOfBirth: DateTime.parse('2020-05-05')*/
  )
];

final farmUser = FarmUser(
    ownerName: "sushil",
    farmName: "sushil dairy",
    location: "chandigarh",
    phoneNo: 8053004565);

void milkRecords(BuildContext context) //TODO: [FUNCTION FOR AVG. MILK COW CARD]
{
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const AvgMilkCowPage()));
}

void cattle(BuildContext context) //TODO: [FUNCTION FOR COW CARD]
{
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const AnimalList()));
}

void feed(BuildContext context) //TODO: [FUNCTION FOR TRANSACTIONS CARD]
{
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const DryCowsPage()));
}

void transactions(BuildContext context) //TODO: [FUNCTION FOR TRANSACTIONS CARD]
{
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const AvgMilkCowPage()));
}

void profile(BuildContext context) {
  //TODO: [FUNCTION FOR BOTTOM PROFILE BUTTON]

  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const ProfilePage()));
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  final Color myColor = const Color(0xFF39445A);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Dairy Management App',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: myColor,
      // Setting color for the app bar
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.notifications),
          color: Colors.white,
          onPressed: () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomePage extends StatefulWidget implements PreferredSizeWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Color totalCowsColor =
        const Color.fromRGBO(224, 191, 184, 1.0); // Green color
    Color milkingCowsColor =
        const Color.fromRGBO(252, 222, 172, 1.0); // Red color
    Color dryCowsColor = const Color.fromRGBO(88, 148, 120, 1.0); // Blue color
    Color avgMilkPerCowColor =
        const Color.fromRGBO(202, 217, 173, 1.0); // Yellow color
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: buildClickableContainer(
                    context: context,
                    value: 'Cattle',
                    imageUrl: 'asset/cattles.jpg',
                    // 'https://static.vecteezy.com/system/resources/previews/014/568/676/original/milk-cow-icon-simple-style-vector.jpg',
                    containerColor:
                        totalCowsColor, // Setting color for this container
                    onTap: () {
                      cattle(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildClickableContainer(
                      context: context,
                      value: 'Feed',
                      imageUrl: 'asset/feed.jpg',
                      // 'https://thumbs.dreamstime.com/b/feeding-cow-stylized-vector-feeding-cow-stylized-vector-silhouette-103872165.jpg',
                      containerColor:
                          milkingCowsColor, // Setting color for this container
                      onTap: () {
                        feed(context);
                      }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: buildClickableContainer(
                      context: context,
                      value: 'Transactions',
                      imageUrl: 'asset/transactions.webp',
                      // 'https://thumbs.dreamstime.com/b/finance-management-linear-icons-data-analysis-symbol-template-graphic-web-design-collection-logo-icon-263711792.jpg',
                      containerColor:
                          dryCowsColor, // Setting color for this container
                      onTap: () {
                        transactions(context);
                      }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildClickableContainer(
                      context: context,
                      value: 'Milk Record',
                      imageUrl: 'asset/avg.jpg',
                      // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA1NYO1taWsdYChV36YpskudbNaYMbzIf3Jw&usqp=CAU',
                      containerColor:
                          avgMilkPerCowColor, // Setting color for this container
                      onTap: () {
                        milkRecords(context);
                      }),
                ),
              ],
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
