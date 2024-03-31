import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/screens/home/animallist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../../models/cattle.dart';
import '../../services/database/cattledatabase.dart';

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

  final List<Map<String, Object>> events = [
    {"event": "abortion", "date": "2022-01-01"},
    {"event": "vaccination", "date": "2022-02-01"},
    {"event": "heifer", "date": "2022-03-01"},
    {"event": "insemination", "date": "2022-04-01"},
    {"event": "vaccination", "date": "2027-04-01"},
  ];


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
        backgroundColor: Color.fromRGBO(13, 152, 186, 1.0),
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Container(
                      child: Text("Details",style: TextStyle(fontWeight:FontWeight.w400,fontSize: 20),),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,10,10,10),
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            Expanded(

                              child: Card(
                              margin: EdgeInsets.fromLTRB(20,10,20,10),
                              // color: Colors.blue[100],
                              //   color: Color.fromRGBO(242, 210, 189, 0.7),
                                color: Colors.green[200],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // shape: const RoundedRectangleBorder(
                                    //     borderRadius:
                                    //     BorderRadius.all(Radius.circular(10))),
                                    // color: Colors.white,
                                    color: Colors.green[200],
                                    // color: Color.fromRGBO(242, 210, 189, 0.7),
                                    margin: const EdgeInsets.all(8),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      child: Text(
                                        "${cattle.age}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Age",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                                                      ),
                            ),
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                // color: Colors.blue[100],
                                color: Color.fromRGBO(242, 210, 189, 0.7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // shape: const RoundedRectangleBorder(
                                      //     borderRadius:
                                      //     BorderRadius.all(Radius.circular(12))),
                                      // color: Colors.blue[100],
                                      color: Color.fromRGBO(242, 210, 189, 0.7),
                                      margin: const EdgeInsets.all(8),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        child: Text(
                                          cattle.sex,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Gender",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),]
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.fromLTRB(20,10,20,10),
                                color: Colors.purple[100],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // shape: const RoundedRectangleBorder(
                                      //     borderRadius:
                                      //     BorderRadius.all(Radius.circular(12))),
                                      color: Colors.purple[100],
                                      margin: const EdgeInsets.all(8),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        child: Text(
                                          "${cattle.weight}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Weight",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.fromLTRB(20,10,20,10),
                                color: Colors.yellow[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Container(
                                      // shape: const RoundedRectangleBorder(
                                      //     borderRadius:
                                      //     BorderRadius.all(Radius.circular(12))),
                                      color: Colors.yellow[200],
                                      margin: const EdgeInsets.all(8),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15,5,15,5),
                                        child: Text(
                                          cattle.breed,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Breed",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.fromLTRB(20,10,20,10),
                                color: Colors.teal[100],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // shape: const RoundedRectangleBorder(
                                      //     borderRadius:
                                      //     BorderRadius.all(Radius.circular(12))),
                                      color: Colors.teal[100],
                                      margin: const EdgeInsets.all(8),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15,5,15,5),
                                        child: Text(
                                          cattle.breed,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.fromLTRB(20,10,20,10),
                                color:Colors.pink[100],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                                      
                                  children: [
                                    Card(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(12))),
                                      color: Colors.pink[100],
                                      margin: const EdgeInsets.all(8),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15,5,15,5),
                                        child: Text(
                                          cattle.breed,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Source of Cattle",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                      child: Container(
                        child: Text("History",style: TextStyle(fontWeight:FontWeight.w400,fontSize: 20),),
                      ),
                    ),
                  Expanded(

                      // child:SingleChildScrollView(
                      //   scrollDirection: Axis.vertical,
                        child: ListView(
                          children: events
                              .map((event) => Padding(
                              padding: EdgeInsets.fromLTRB(10,7,10,7),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.blue[100],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [

                                  Container(
                                    // padding: EdgeInsets.all(10),
                                   width: 130,
                                    height: 60,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          if (event['event'].toString() == 'abortion')
                                          Image.asset('asset/Cross_img.png',width: 30,height: 35,),

                                          if (event['event'].toString() == 'vaccination')
                                            Image.asset('asset/Vaccination.png',width: 30,height: 35,),

                                          if (event['event'].toString() == 'heifer')
                                            Image.asset('asset/heifer.png',width: 30,height: 35,),

                                          if (event['event'].toString() == 'insemination')
                                            Image.asset('asset/Vaccination.png',width: 30,height: 35,),

                                          Text(
                                        " ${  capitalizeFirstLetterOfEachWord(event['event'].toString())}",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16),
                                        ),

                                        ]
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    // width: 80,
                                    child: Text(
                                      event["date"].toString(), // Display the raw date string
                                      softWrap: false,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("Deleting item");
                                      // Implement deletion logic here
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                                              ],
                                                            ),
                                ),
                              ))
                              .toList(),
                        ),
                    // ),

                    )


                    // GridView(
                    //
                    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       crossAxisSpacing: 0, // Spacing between columns
                    //       childAspectRatio: 1.5),
                    //
                    //   children: [
                    //             Card(
                    //               margin: EdgeInsets.fromLTRB(20,20,20,20),
                    //               color: Colors.blue[100],
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Container(
                    //                     // shape: const RoundedRectangleBorder(
                    //                     //     borderRadius:
                    //                     //     BorderRadius.all(Radius.circular(10))),
                    //                     // color: Colors.white,
                    //                     color: Colors.blue[100],
                    //
                    //                     margin: const EdgeInsets.all(8),
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    //                       child: Text(
                    //                         "${cattle.age}",
                    //                         style: const TextStyle(
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 16,
                    //                           color: Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const Text(
                    //                     "Age",
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold,color: Colors.white, fontSize: 16),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             Card(
                    //               margin: EdgeInsets.all(20),
                    //               color: Colors.blue[100],
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Container(
                    //                     // shape: const RoundedRectangleBorder(
                    //                     //     borderRadius:
                    //                     //     BorderRadius.all(Radius.circular(12))),
                    //                     color: Colors.blue[100],
                    //                     margin: const EdgeInsets.all(8),
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    //                       child: Text(
                    //                         cattle.sex,
                    //                         style: const TextStyle(
                    //                           fontSize: 16,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const Text(
                    //                     "Gender",
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white,),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //
                    //
                    //
                    //
                    //   ],
                    // ),
                    //
                    //
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
  final List<String> stageOptions = [
    'Milked',
    'Heifer',
    'Insemination',
    'Abortion',
    'Dry',
    'Calved'
  ];

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
        breed: _breedTextController.text,
        sex: _selectedGender.toString(),
        weight: int.parse(_weightTextController.text),
        state: _selectedStage.toString());

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
                    hintText: "YYYY-MM-DD",
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
                  value: _selectedStage,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: stageOptions.map((String gender) {
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

String capitalizeFirstLetterOfEachWord(String input) {
  if (input.isEmpty) return "";

  var words = input.toLowerCase().split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = words[i][0].toUpperCase() + words[i].substring(1);
  }
  return words.join(' ');
}
