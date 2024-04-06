import 'package:farm_expense_mangement_app/models/cattle.dart';
import 'package:farm_expense_mangement_app/screens/home/animaldetails.dart';
import 'package:farm_expense_mangement_app/screens/home/newcattle.dart';
import 'package:farm_expense_mangement_app/services/database/cattledatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnimalList extends StatefulWidget {
  const AnimalList({super.key});

  @override
  State<AnimalList> createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Set<String> selectedStates = <String>{};
  Set<String> selectedGenders = <String>{};

  late DatabaseServicesForCattle cattleDb;
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
      allCattle =
          snapshot.docs.map((doc) => Cattle.fromFireStore(doc, null)).toList();
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewCattle()),
    );
  }

  Future<Widget?> _showFilter(BuildContext context) async {
    return showDialog<Widget>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:            const Text(
              'Filter Option',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'State:',
                  style: TextStyle(
                      color: Colors.blue,
                    fontSize: 20
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilterChip(
                          label: const Text('Milked'),
                          selected: selectedStates.contains('Milked'),
                          onSelected: (bool selected) => {
                            setState(() {
                              if (selected) {
                                selectedStates.add('Milked');
                              } else {
                                selectedStates.remove('Milked');
                              }
                            })
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilterChip(
                          label: const Text('Heifer'),
                          selected: selectedStates.contains('Heifer'),
                          onSelected: (bool selected) => {
                            setState(() {
                              if (selected) {
                                selectedStates.add('Heifer');
                              } else {
                                selectedStates.remove('Heifer');
                              }
                            })
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilterChip(
                          label: const Text('Insemination'),
                          selected: selectedStates.contains('Insemination'),
                          onSelected: (bool selected) => {
                            setState(() {
                              if (selected) {
                                selectedStates.add('Insemination');
                              } else {
                                selectedStates.remove('Insemination');
                              }
                            })
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilterChip(
                          label: const Text('Abortion'),
                          selected: selectedStates.contains('Abortion'),
                          onSelected: (bool selected) => {
                            setState(() {
                              if (selected) {
                                selectedStates.add('Abortion');
                              } else {
                                selectedStates.remove('Abortion');
                              }
                            })
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilterChip(
                          label: const Text('Dry'),
                          selected: selectedStates.contains('Dry'),
                          onSelected: (bool selected) => {
                            setState(() {
                              if (selected) {
                                selectedStates.add('Dry');
                              } else {
                                selectedStates.remove('Dry');
                              }
                            })
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilterChip(
                          label: const Text('Calved'),
                          selected: selectedStates.contains('Calved'),
                          onSelected: (bool selected) => {
                            setState(() {
                              if (selected) {
                                selectedStates.add('Calved');
                              } else {
                                selectedStates.remove('Calved');
                              }
                            })
                          }),
                    ),
                  ],
                ),
                const Text(
                  'Gender:',
                  style: TextStyle(
                      color: Colors.blue,
                    fontSize: 20
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilterChip(
                          label: const Text('Female'),
                          selected: selectedGenders.contains('Female'),
                          onSelected: (bool selected) => {
                            setState(() {
                              if (selected) {
                                selectedGenders.add('Female');
                              } else {
                                selectedGenders.remove('Female');
                              }
                            })
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilterChip(
                          label: const Text('Male'),
                          selected: selectedGenders.contains('Male'),
                          onSelected: (bool selected) => {
                            setState(() {
                              if (selected) {
                                selectedGenders.add('Male');
                              } else {
                                selectedGenders.remove('Male');
                              }
                            })
                          }),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     TextButton(
                //         onPressed: () {
                //
                //           setState(() {
                //             selectedGenders.clear();
                //             selectedStates.clear();
                //
                //           });
                //           Navigator.pop(context);
                //         },
                //         child: const Text('Clear all')),
                //     TextButton(
                //         onPressed: () {
                //           Navigator.pop(context);
                //         },
                //         child: const Text('Confirm Filter'))
                //   ],
                // ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {

                    setState(() {
                      selectedGenders.clear();
                      selectedStates.clear();

                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Clear all')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Confirm Filter'))
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Cattle> filteredCattle = allCattle;

    if (selectedStates.isNotEmpty) {
      filteredCattle = filteredCattle.where((cattle) {
        for (var state in selectedStates) {
          if (cattle.state.contains(state)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    if (selectedGenders.isNotEmpty) {
      filteredCattle = filteredCattle.where((cattle) {
        for (var gender in selectedGenders) {
          if (cattle.sex.contains(gender)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Cattles',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
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
              color: Colors.black,
            ),
            onPressed: () {
              // Implement filter options

              setState(() {
                _showFilter(context);
              });
            },
          ),
        ],
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            // _HomePageState();
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: filteredCattle.length,
        itemBuilder: (context, index) {
          final cattleInfo = filteredCattle[index];
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
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        child: const Icon(Icons.add),
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
        close(
            context,
            query.isEmpty
                ? Cattle(rfid: '', breed: '')
                : Cattle(rfid: '', breed: ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = query.isEmpty
        ? allCattle
        : allCattle.where((cattle) => cattle.rfid.contains(query)).toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            color: Colors.blue[200],
          ),
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  color: Colors.blue[200],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      size: 35, color: Colors.white),
                  onPressed: () {
                    // Implement filter functionality
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Cattle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      // Implement search functionality
                    },
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  color: Colors.blue[200],
                ),
                child: IconButton(
                  icon: const Icon(Icons.clear, size: 35, color: Colors.white),
                  onPressed: () {
                    close(
                        context,
                        query.isEmpty
                            ? Cattle(rfid: '', breed: '')
                            : Cattle(rfid: '', breed: ''));
                    // Implement filter functionality
                  },
                ),
              ),
            ],
          ),
        ),
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
        ? allCattle
        : allCattle.where((cattle) => cattle.rfid.contains(query)).toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final cattleInfo = searchResults[index];
        return CattleListItem(
          cattle: cattleInfo,
          onTap: () {
            viewCattleDetail1(context, cattleInfo);
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Search Cattle';
}

class CattleListItem extends StatefulWidget {
  final Cattle cattle;
  final VoidCallback onTap;

  const CattleListItem({
    required this.cattle,
    required this.onTap,
    super.key,
  });

  @override
  State<CattleListItem> createState() => _CattleListItemState();
}

class _CattleListItemState extends State<CattleListItem> {
  // static const colorCard1 = Color(0xFF90CAF9);
  // static const colorCard2 = Color(0xFFFFCC80);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        // color: Colors.orange[100],
        // color: Colors.white70,
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        surfaceTintColor: Colors.lightBlue[100],
        shadowColor: Colors.white70,
        elevation: 8,

        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(242, 210, 189, 0.8),
            borderRadius: BorderRadius.circular(8),
            // gradient: const LinearGradient(
            //     colors: [colorCard1,colorCard2]
            // )
          ),
          child: ListTile(
            // textColor: Colors.brown,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: widget.cattle.sex == 'Female'
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                      foregroundDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'asset/cow.jpg',
                        fit: BoxFit
                            .cover, // Replace with your image asset for male
                        // width: 50,
                        // height: 50,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                      foregroundDecoration:
                          const BoxDecoration(shape: BoxShape.circle),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'asset/bull.jpg', // Replace with your image asset for female
                        fit: BoxFit.cover,
                      ),
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
                  widget.cattle.rfid,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Breed:${widget.cattle.breed}"),
                  Text("Age:${widget.cattle.age}")
                ]),
            // trailing: const Icon(Icons.arrow_forward_ios_outlined),
          ),
        ),
      ),
    );
  }
}
