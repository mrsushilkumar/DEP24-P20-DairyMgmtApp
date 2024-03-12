import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/models/cattle.dart';
import 'package:farm_expense_mangement_app/screens/home/animaldetails.dart';
import 'package:farm_expense_mangement_app/screens/home/homepage.dart';
import 'package:farm_expense_mangement_app/screens/home/newcattle.dart';
import 'package:farm_expense_mangement_app/services/database/cattledatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final cattleDemo = Cattle(rfid: '12345', breed: '');

class AnimalList extends StatefulWidget {
  const AnimalList({Key? key}) : super(key: key);

  @override
  State<AnimalList> createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseServicesForCattle cattleDb;
  late Cattle cattle;
  late List<Cattle> allCattle = [];

  @override
  void initState() {
    super.initState();
    cattleDb = DatabaseServicesForCattle(uid);
    _fetchCattle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchCattle() async {
    final snapshot = await cattleDb.infoFromServerAllCattle(uid);
    setState(() {
      allCattle = snapshot.docs
          .map((doc) => Cattle.fromFireStore(doc, null))
          .toList();
    });
  }

  void viewCattleDetail(Cattle cattle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetails(rfid: cattle.rfid),
      ),
    );
  }

  void addCattle(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AddNewCattle()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Animals',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF39445A),
        actions: [
          IconButton(

            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: AnimalSearchDelegate(allCattle),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () {
              // Implement filter options
              _showFilterOptions(context);

            },
          ),

        ],
        // leading: IconButton(
        //   color:Colors.white,
        //   icon:const Icon(
        //     Icons.arrow_back,
        //   ),
        //     onPressed:() {
        //       // _HomePageState();
        // },
        // ),
      ),
      body: ListView.builder(
        itemCount: allCattle.length,
        itemBuilder: (context, index) {
          final cattleInfo = allCattle[index];
          return CattleListItem(
            cattle: cattleInfo,
            onTap: () {
              viewCattleDetail(cattleInfo);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCattle(context);
        },
        tooltip: 'Add Cattle',
        child: const Icon(Icons.add),
      ),
    );
  }


  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Filter Options',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildFilterOption('State:', ['Milked', 'Heifer', 'Insemination', 'Abortion', 'Dry', 'Calved']),
              SizedBox(height: 20),
              _buildFilterOption('Gender:', ['Male', 'Female']),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement confirm filters functionality here
                    },
                    child: Text('Confirm Filters'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement clear filters functionality here
                    },
                    child: Text('Clear Filters'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _buildFilterOption(String title, List<String> options) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey[300]), // Adding border
        borderRadius: BorderRadius.circular(8.0), // Adding border radius
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Changing text color
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              return FilterChip(
                label: Text(option),
                onSelected: (isSelected) {
                  // Handle chip selection
                },
                selectedColor: Colors.blue, // Changing chip color
                selected: false, // Setting initial selection state
              );
            }).toList(),
          ),
        ],
      ),
    );


}




}

class AnimalSearchDelegate extends SearchDelegate<Cattle> {
  final List<Cattle> allCattle;

  AnimalSearchDelegate(this.allCattle);

  void viewCattleDetail1(BuildContext context, Cattle cattle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetails(rfid: cattle.rfid),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, query.isEmpty ? Cattle(rfid: '', breed: '') : Cattle(rfid: '', breed: ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = query.isEmpty
        ? allCattle
        : allCattle
        .where((cattle) => cattle.rfid.contains(query))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Customize background color
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back
        //   ,color: Colors.black,),
        //   onPressed: () {
        //     close(context, query.isEmpty ? Cattle(rfid: '', breed: '') : Cattle(rfid: '', breed: ''));
        //   },
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear
              ,color: Colors.black,),
            onPressed: () {
              query = '';
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final cattleInfo = searchResults[index];
          return CattleListItem(
            cattle: cattleInfo,
            onTap: () {
              close(context, cattleInfo);
              // Navigate to next page
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = query.isEmpty
        ? []
        : allCattle
        .where((cattle) => cattle.rfid.contains(query))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final cattleInfo = searchResults[index];
        return CattleListItem(
          cattle: cattleInfo,
          onTap: () {
            query = cattleInfo.rfid;
            close(context, cattleInfo);
            viewCattleDetail1(context, cattleInfo);
            // Navigate to next page
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Search Cattle';
}

class CattleListItem extends StatelessWidget {
  final Cattle cattle;
  final VoidCallback onTap;

  const CattleListItem({
    required this.cattle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.brown[100],
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(2),
            child: cattle.sex == 'Female'
                ? Image.asset(
              'asset/cow.jpg', // Replace with your image asset for male
              width: 50,
              height: 50,
            )
                : Image.asset(
              'asset/bull.jpg', // Replace with your image asset for female
              width: 50,
              height: 50,
            ),
          ),
          title: Row(
            children: [
              const Text(
                'RF id : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                cattle.rfid,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: AnimalList()));
}
