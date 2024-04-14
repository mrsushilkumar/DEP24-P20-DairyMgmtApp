
import 'package:farm_expense_mangement_app/screens/home/milkavgpage.dart';
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
          // IconButton(
          //   color:Colors.black,
          //   onPressed: () {
          //     // Handle filter action
          //   },
          //   icon: const Icon(Icons.filter_list),
          // ),

        ],
        leading: IconButton(
          color:Colors.black,
          icon:const Icon(
            Icons.arrow_back,
          ),
          onPressed:() {
            // HomeAppBar();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AvgMilkPage()));
          },
        ),
      ),
      body: Column(
        children:[
          Expanded(
            flex: 1,
              child: Center(
                child: Text(
                  'On Date: ${widget.dateOfMilk!.day}-${widget.dateOfMilk!.month}-${widget.dateOfMilk!.year}',
                  style: const TextStyle(
                    fontSize: 20
                  ),
                ),
              )
          ),
          Expanded(
            flex: 16,
            child: ListView.builder(
              itemCount: _allMilkInDate.length,
              itemBuilder: (context, index) {
                final data = _allMilkInDate[index];
                return MilkDataRow(data: data);
              },
            ),
          ),

        ],
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

class MilkDataRow extends StatefulWidget {
  final Milk data;

  const MilkDataRow({super.key, required this.data});

  @override
  State<MilkDataRow> createState() => _MilkDataRowState();
}

class _MilkDataRowState extends State<MilkDataRow> {



  void editDetail (){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditMilkByDate(data: widget.data)));
  }

  @override
  Widget build(BuildContext context) {

    final double totalMilk = widget.data.evening + widget.data.morning;

    return GestureDetector(
      onTap: editDetail,
      child: Card(
        // color: Colors.blue[100],
        color: const Color.fromRGBO(230, 255, 255, 1),

        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8,13,8,13),
          child: Row(
            children: [
              Image.asset('asset/cow.jpg',width: 30,height: 35,),
              const SizedBox(width: 10.0),
              Expanded(flex: 1,child: Text("RFID: ${widget.data.rfid}"),),
              const SizedBox(width: 10.0),
              Image.asset('asset/morning.webp',width: 30,height: 35,),
              Expanded(flex: 1,child: Text("${widget.data.morning.toStringAsFixed(2)}L"),),

              Image.asset('asset/evening2.jpg',width: 25,height: 35,),
              Expanded(flex: 1,child: Text(" ${widget.data.evening.toStringAsFixed(2)}L"),),

              const SizedBox(width: 9.0),

              Expanded(flex: 2,child: Text("Total Milk: ${totalMilk.toStringAsFixed(2)}L"),),
            ],
          ),
        ),
      ),
    );
  }
}



class EditMilkByDate extends StatefulWidget {
  final Milk data;
  const EditMilkByDate({super.key,required this.data});

  @override
  State<EditMilkByDate> createState() => _EditMilkByDateState();
}

class _EditMilkByDateState extends State<EditMilkByDate> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late DatabaseForMilk db;
  late DatabaseForMilkByDate dbByDate;

  double? milkInMorning;
  double? milkInEvening;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseForMilk(uid);
    dbByDate = DatabaseForMilkByDate(uid);
    milkInMorning = widget.data.morning;
    milkInEvening = widget.data.evening;

  }


  void _editMilkDetail(Milk milk) async{
    await db.infoToServerMilk(milk);
    final MilkByDate  milkByDate;
    final snapshot = await dbByDate.infoFromServerMilk(milk.dateOfMilk!);
    if(snapshot.exists)
    {
      milkByDate = MilkByDate.fromFireStore(snapshot, null);
    }
    else
    {
      milkByDate = MilkByDate(dateOfMilk: milk.dateOfMilk);
      await dbByDate.infoToServerMilk(milkByDate);
    }
    final double totalMilk = milkByDate.totalMilk + milk.morning+milk.evening-widget.data.evening-widget.data.morning;
    await dbByDate.infoToServerMilk(MilkByDate(dateOfMilk: milk.dateOfMilk,totalMilk: totalMilk));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        title: const Text('Edit Milk Detail'),
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MilkByDatePage(dateOfMilk: widget.data.dateOfMilk,)));
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Rf id : ${widget.data.rfid}',
                style: const TextStyle(
                  fontSize: 20,
                  // color: Colors.blue
                ),
              ),
              Text(
                'On Date : ${widget.data.dateOfMilk!.day}-${widget.data.dateOfMilk!.month}-${widget.data.dateOfMilk!.year}',
                style: const TextStyle(
                    fontSize: 20,
                    // color: Colors.blue
                ),
              ),
              const SizedBox(height: 20.0),
              _buildInputBox(
                child: TextFormField(
                  initialValue: milkInMorning.toString(),
                  onChanged: (value) {
                    milkInMorning = double.tryParse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Morning Milk',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildInputBox(
                child: TextFormField(
                  initialValue:  milkInEvening.toString(),
                  onChanged: (value) {
                    milkInEvening = double.tryParse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Evening Milk',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

                  ),
                  onPressed: () {
                    // Handle add action
                    if (
                        milkInMorning != null &&
                        milkInEvening != null
                        ) {
                      Milk newMilkData = Milk(
                          rfid: widget.data.rfid,
                          morning: milkInMorning!,
                          evening: milkInEvening!,
                          dateOfMilk: widget.data.dateOfMilk
                        // totalMilk: milkInMorning! + milkInEvening!,
                      );
                      // Here, you can add the new milk data to your list or database
                      _editMilkDetail(newMilkData);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MilkByDatePage(dateOfMilk: widget.data.dateOfMilk)
                          )
                      );// Close the add milk data page
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Add',style: TextStyle(fontSize: 20),),
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
      child: child,
    );
  }
}

