
import 'package:farm_expense_mangement_app/models/milk.dart';
import 'package:farm_expense_mangement_app/services/database/milkdatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'milk/milkbydate.dart';


class AvgMilkPage extends StatefulWidget {
  const AvgMilkPage({super.key});

  @override
  State<AvgMilkPage> createState() => _AvgMilkPageState();
}

class _AvgMilkPageState extends State<AvgMilkPage> with RouteAware{
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final RouteObserver<Route<dynamic>> _routeObserver = RouteObserver<Route<dynamic>>();

  late DatabaseForMilkByDate db;

  List<MilkByDate> _allMilkByDate = [];

  Future<void> _fetchAllMilkByDate() async {
    final snapshot = await db.infoFromServerAllMilk();
    setState(() {
      _allMilkByDate = [];
      _allMilkByDate = snapshot.docs.map((doc) =>  MilkByDate.fromFireStore(doc,null)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseForMilkByDate(uid);
    _fetchAllMilkByDate();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context)!);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    // super.didPopNext();
    _fetchAllMilkByDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        // backgroundColor: Colors.blue[100],
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

        title: const Center(child: Text('Milk Records')),
        actions: [
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
        itemCount: _allMilkByDate.length,
        itemBuilder: (context, index) {
          return MilkDataRowByDate(data: _allMilkByDate[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add action
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AddMilkDataPage()),
          );
        },
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

        child: const Icon(Icons.add),
      ),
    );
  }


}


class MilkDataRowByDate extends StatefulWidget {
  final MilkByDate data;

  const MilkDataRowByDate({super.key, required this.data});

  @override
  State<MilkDataRowByDate> createState() => _MilkDataRowByDateState();
}

class _MilkDataRowByDateState extends State<MilkDataRowByDate> {

  void viewMilkByDate() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MilkByDatePage(dateOfMilk: (widget.data.dateOfMilk))));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewMilkByDate,
      child: Card(
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        color: const Color.fromRGBO(
            240, 255, 255, 1), // Increase top margin for more gap between cards
        elevation: 8, // Increase card elevation for stronger shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(
            color: Colors.white, // Fluorescent color boundary
            width: 3, // Width of the boundary
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                  foregroundDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'asset/cow1.jpg',
                    fit: BoxFit.cover,
                    width: 70, // Adjust width to maximize the size
                    height: 150, // Adjust height to maximize the size
                  ),
                ),
            ),
            title: Text(
                "Date: ${widget.data.dateOfMilk?.day}-${widget.data.dateOfMilk?.month}-${widget.data.dateOfMilk?.year}",
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
              // const SizedBox(width: 10.0),
              // Image.asset('asset/morning.webp',width: 30,height: 35,),
              // Expanded(flex: 1,child: Text("${data.morning.toStringAsFixed(2)}L"),),
              //
              // Image.asset('asset/evening2.jpg',width: 25,height: 35,),
              // Expanded(flex: 1,child: Text(" ${data.evening.toStringAsFixed(2)}L"),),
              subtitle: Row(
                  children: [
                    const Text(
                        "Total Milk: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("${widget.data.totalMilk.toStringAsFixed(2)}L")
                  ]
              ),

          ),
        ),
      ),
    );
  }
}


class AddMilkDataPage extends StatefulWidget {
  const AddMilkDataPage({super.key});

  @override
  State<AddMilkDataPage> createState() => _AddMilkDataPageState();
}

class _AddMilkDataPageState extends State<AddMilkDataPage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late DatabaseForMilk db;
  late DatabaseForMilkByDate dbByDate;


  String? rfid;
  double? milkInMorning;
  double? milkInEvening;
  DateTime? milkingDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseForMilk(uid);
    dbByDate = DatabaseForMilkByDate(uid);
  }


  void _addMilk(Milk data) async {
    await db.infoToServerMilk(data);
    final MilkByDate  milkByDate;
    final snapshot = await dbByDate.infoFromServerMilk(data.dateOfMilk!);
    if(snapshot.exists)
      {
        milkByDate = MilkByDate.fromFireStore(snapshot, null);
      }
    else
      {
        milkByDate = MilkByDate(dateOfMilk: data.dateOfMilk);
        await dbByDate.infoToServerMilk(milkByDate);
      }
    final double totalMilk = milkByDate.totalMilk + data.morning+data.evening;
    await dbByDate.infoToServerMilk(MilkByDate(dateOfMilk: data.dateOfMilk,totalMilk: totalMilk));


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),

      appBar: AppBar(
        title: const Text('Add Milk Data'),
        // backgroundColor: Colors.blue[100],
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AvgMilkPage()));
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
              _buildInputBox(
                child: TextFormField(
                  onChanged: (value) {
                    rfid = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'RFID',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildInputBox(
                child: TextFormField(
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
              _buildInputBox(
                child: InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        milkingDate = pickedDate;
                      });
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: milkingDate != null ? '${milkingDate!.year}-${milkingDate!.month}-${milkingDate!.day}' : '',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Milking Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: InputBorder.none,
                      ),
                    ),
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
                    if (rfid != null &&
                        milkInMorning != null &&
                        milkInEvening != null &&
                        milkingDate != null) {
                      Milk newMilkData = Milk(
                          rfid: rfid!,
                          morning: milkInMorning!,
                          evening: milkInEvening!,
                          dateOfMilk: milkingDate
                        // totalMilk: milkInMorning! + milkInEvening!,
                      );
                      // Here, you can add the new milk data to your list or database
                      _addMilk(newMilkData);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AvgMilkPage()
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
