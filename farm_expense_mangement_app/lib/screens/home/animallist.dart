

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/models/cattle.dart';
import 'package:farm_expense_mangement_app/screens/home/animaldetails.dart';
import 'package:farm_expense_mangement_app/screens/home/newcattle.dart';
import 'package:farm_expense_mangement_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final cattleDemo = Cattle(rfid: '12345', breed: 'cow',/* dateOfBirth: DateTime.parse('2020-05-05')*/);

class AnimalList extends StatefulWidget {

  const AnimalList({super.key});

  @override
  State<AnimalList> createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {

  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseServicesForCattle cattleDb;
  late Cattle cattle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cattleDb = DatabaseServicesForCattle(uid);
  }

  void viewCattleDetail(Cattle cattle)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AnimalDetails(cattle: cattle)));
  }

  void addCattle(BuildContext context)
  {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddNewCattle()));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchCattle()
  {
    return cattleDb.infoFromServerAllCattle(uid);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Animals',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF39445A),
        leading: IconButton(
          color: Colors.white,
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              // Implement search button functionality here
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),

      body:FutureBuilder(
            future: _fetchCattle(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context,index) {
                      return Card(
                        color: Colors.grey.shade400,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                          width: double.infinity,
                          height: 50,
                        ),
                      );
                    },
                  );
                }
              else if(snapshot.hasData)
                {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index)
                        {
                          final cattleInfo = Cattle.fromFireStore(snapshot.data!.docs[index], null);
                          return  GestureDetector(
                            onTap: (){
                              setState(() {
                                cattle = cattleInfo;
                              });
                              viewCattleDetail(cattleInfo);
                            },
                            child: Card(
                              color: Colors.brown[100],
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: cattleInfo.sex == 'Female'
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
                                      cattleInfo.rfid,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),/*
                                    Text('${cattleInfo.dateOfBirth}'),*/
                                  ],
                                ),

                                trailing: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios_outlined),onPressed: () {
                                  // Implement the functionality when the arrow button is pressed
                                  setState(() {
                                    cattle = cattleInfo;
                                  });
                                  viewCattleDetail(cattleInfo);

                                },
                                ),
                                onTap: () {
                                  // Implement functionality when card is tapped
                                },
                              ),
                            ),
                          );
                        }


                    ),
                  );
                }
              else
                {
                  return const Text('Error in Fetch');
                }
            }
          ),


      floatingActionButton: FloatingActionButton(
        backgroundColor:Colors.brown[70],
        onPressed: () {
          // Implement functionality to add more cattle
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Filter Options',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('State:', ['Milked', 'Heifer', 'Insemination', 'Abortion', 'Dry', 'Calved']),
              const SizedBox(height: 20),
              _buildFilterOption('Gender:', ['Bull', 'Cow']),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement confirm filters functionality here
                    },
                    child: const Text('Confirm Filters'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement clear filters functionality here
                    },
                    child: const Text('Clear Filters'),
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
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Changing text color
            ),
          ),
          const SizedBox(height: 10),
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

