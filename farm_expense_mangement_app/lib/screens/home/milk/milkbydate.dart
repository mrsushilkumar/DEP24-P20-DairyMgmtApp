
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/milk.dart';
import '../../../services/database/milkdatabase.dart';

class MilkByDatePage extends StatefulWidget {
  final DateTime? dateOfMilk;
  const MilkByDatePage({super.key,this.dateOfMilk});

  @override
  State<MilkByDatePage> createState() => _MilkByDatePageState();
}

class _MilkByDatePageState extends State<MilkByDatePage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late DatabaseForMilk db;

  List<Milk> _allMilkInDate = [];


  Future<void> _fetchAllMilk() async {
    final DateTime dateTime = widget.dateOfMilk!;
    final snapshot = await db.infoFromServerAllMilk(dateTime);
    setState(() {
      _allMilkInDate = snapshot.docs.map((doc) => Milk.fromFireStore(doc,null)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseForMilk(uid);
    _fetchAllMilk();

  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor:  const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        // backgroundColor: Colors.blue[100],
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

        title: const Center(child: Text('Milk Record')),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {
              // Handle search action
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            color:Colors.black,
            onPressed: () {
              // Handle filter action
            },
            icon: const Icon(Icons.filter_list),
          ),

        ],
        leading: IconButton(
          color:Colors.black,
          icon:const Icon(
            Icons.arrow_back,
          ),
          onPressed:() {
            // HomeAppBar();
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _allMilkInDate.length,
        itemBuilder: (context, index) {
          final data = _allMilkInDate[index];
          return MilkDataRow(data: data);
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Handle add action
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const AddMilkDataPage()),
      //     );
      //   },
      //   backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
      //
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class MilkDataRow extends StatelessWidget {
  final Milk data;

  const MilkDataRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    final double totalMilk = data.evening +data.morning;
    return Card(
      // color: Colors.blue[100],
      color: const Color.fromRGBO(230, 255, 255, 1),

      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8,13,8,13),
        child: Row(
          children: [
            Image.asset('asset/cow.jpg',width: 30,height: 35,),
            const SizedBox(width: 10.0),
            Expanded(flex: 1,child: Text("RFID: ${data.rfid}"),),
            const SizedBox(width: 10.0),
            Image.asset('asset/morning.webp',width: 30,height: 35,),
            Expanded(flex: 1,child: Text("${data.morning.toStringAsFixed(2)}L"),),

            Image.asset('asset/evening2.jpg',width: 25,height: 35,),
            Expanded(flex: 1,child: Text(" ${data.evening.toStringAsFixed(2)}L"),),

            const SizedBox(width: 9.0),

            Expanded(flex: 2,child: Text("Total Milk: ${totalMilk.toStringAsFixed(2)}L"),),
          ],
        ),
      ),
    );
  }
}

