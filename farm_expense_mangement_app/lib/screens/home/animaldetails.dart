import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/screens/home/animallist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/cattle.dart';
import '../../services/database/cattleDatabase.dart';

class AnimalDetails extends StatefulWidget {
  final String rfid;
  const AnimalDetails({super.key, required this.rfid});

  @override
  State<AnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _streamController;

  // late DocumentSnapshot<Map<String,dynamic>> snapshot;
  late DatabaseServicesForCattle cattleDb;
  late Cattle cattle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cattleDb = DatabaseServicesForCattle(uid);

    _streamController = _fetchCattleDetail();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _fetchCattleDetail() {
    return cattleDb.infoFromServer(widget.rfid).asStream();
  }

  void editCattleDetail() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAnimalDetail(cattle: cattle)));
  }

  void deleteCattle() {
    cattleDb
        .deleteCattle(widget.rfid)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Deleted'),
                duration: Duration(seconds: 2),
              ),
            ));
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AnimalList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.rfid,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                deleteCattle();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                editCattleDetail();
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: _streamController,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('Please Wait ..'),
              );
            } else if (snapshot.hasData) {
              cattle = Cattle.fromFireStore(snapshot.requireData, null);
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                children: [
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          color: Colors.grey.shade500,
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(
                              "${cattle.age}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Age",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          color: Colors.grey.shade500,
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(
                              cattle.sex,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Gender",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          color: Colors.grey.shade500,
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(
                              "${cattle.weight}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Weight",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          color: Colors.grey.shade500,
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(
                              cattle.breed,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Breed",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          color: Colors.grey.shade500,
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(
                              "${cattle.lactationCycle}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Lactation\nCycle",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: Text('Error in fetch'),
              );
            }
          }),
    );
  }
}

class EditAnimalDetail extends StatefulWidget {
  final Cattle cattle;

  const EditAnimalDetail({super.key, required this.cattle});

  @override
  State<EditAnimalDetail> createState() => _EditAnimalDetailState();
}

class _EditAnimalDetailState extends State<EditAnimalDetail> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _rfidTextController = TextEditingController();
  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _breedTextController = TextEditingController();
  // final TextEditingController _tagNumberController3 = TextEditingController();

  String? _selectedGender; // Variable to store selected gender
  final TextEditingController _birthDateController = TextEditingController();
  String? _selectedSource;
  String? _selectedStage;

  // Variable to store selected gender

  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> sourceOptions = [
    'Born on Farm',
    'Purchased'
  ]; // List of gender options
  final List<String> stageOptions = ['Lactating', 'Non-Lactating'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked.day.toString() != _birthDateController.text) {
      setState(() {
        _birthDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late final DatabaseServicesForCattle cattleDb;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cattleDb = DatabaseServicesForCattle(uid);
    _breedTextController.text = widget.cattle.breed;
    _weightTextController.text = widget.cattle.weight.toString();
  }

  void updateCattleButton(BuildContext context) {
    final cattle = Cattle(
        rfid: widget.cattle.rfid,
        age: 4,
        lactationCycle: 2,
        breed: _breedTextController.text,
        sex: _selectedGender.toString(),
        weight: int.parse(_weightTextController.text));

    cattleDb.infoToServerSingleCattle(cattle);

    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AnimalDetails(
                  rfid: widget.cattle.rfid,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Cattle ${widget.cattle.rfid}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AnimalDetails(rfid: widget.cattle.rfid)));
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 8, 0, 26),
              //   child: TextFormField(
              //     controller: _rfidTextController,
              //     decoration: InputDecoration(
              //       labelText: 'Enter The RFID*',
              //       border: const OutlineInputBorder(),
              //       filled: true,
              //       fillColor: Colors.grey[200],
              //     ),
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter tag number';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              // const SizedBox(height: 0.00008),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender*',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _weightTextController,
                  decoration: InputDecoration(
                    labelText: 'Enter The Weight',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedSource,
                  decoration: InputDecoration(
                    labelText: 'Source of Cattle*',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: sourceOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSource = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Source';
                    }
                    return null;
                  },
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  controller: _breedTextController,
                  decoration: InputDecoration(
                    labelText: 'Enter The Breed',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStage = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process the data
                        // For example, save it to a database or send it to an API
                        updateCattleButton(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Cattle Details updated Successfully!!')),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[200]),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _rfidTextController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
}
