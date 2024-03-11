

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/models/cattle.dart';
import 'package:farm_expense_mangement_app/screens/home/animaldetails.dart';
import 'package:farm_expense_mangement_app/screens/home/newcattle.dart';
import 'package:farm_expense_mangement_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// final cattleDemo = Cattle(rfid: '12345', breed: 'cow',/* dateOfBirth: DateTime.parse('2020-05-05')*/);

class AnimalList extends StatefulWidget {

  const AnimalList({super.key});

  @override
  State<AnimalList> createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {

  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late bool _searchBar;
  late final TextEditingController _controllerSearchBar = TextEditingController();
  late  Stream<QuerySnapshot<Map<String,dynamic>>> _streamController;

  late DatabaseServicesForCattle cattleDb;
  late Cattle cattle;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cattleDb = DatabaseServicesForCattle(uid);
    _searchBar = false;
    _streamController = _fetchCattle();
  }

  void viewCattleDetail(Cattle cattle) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AnimalDetails(rfid: cattle.rfid,)));
  }

  void addCattle(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewCattle()));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchCattle()
  {
    return cattleDb.infoFromServerAllCattle(uid).asStream();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchCattleWithRfid(String queryData)
  {
    return cattleDb.infoFromServerWithSearch(queryData).asStream();
  }


  void _searchInCattle(String queryData){
    if(queryData.isEmpty)
      {
        setState(() {
          _streamController = _fetchCattle();
        });
      }
    else
      {
        setState(() {
          _streamController = _fetchCattleWithRfid(queryData);
        });
      }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: (!_searchBar) ? const Text(
          'Animals',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        ) : TextField(
          controller: _controllerSearchBar,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,

          ),
          onChanged: (value){
            setState(() {
              _controllerSearchBar.text = value;
              _searchInCattle(_controllerSearchBar.text);
            });
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF39445A),
        leading: IconButton(
          color: Colors.white,
            onPressed: (){
            setState(() {
              if(_searchBar)
              {
                _searchBar = false;
                _controllerSearchBar.text = '';
                _streamController = _fetchCattle();
              }
              else {
                Navigator.pop(context);
              }
            });
            },
            icon: const Icon(Icons.arrow_back)
        ),
        actions: (!_searchBar) ? [
           IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              // Implement search button functionality here
              setState(() {
                _searchBar =! _searchBar;
              });
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ] : [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),],
      ),

      body:StreamBuilder(
            stream: _streamController,
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
                  return const Center(child: Text('Error in Fetch'));
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

