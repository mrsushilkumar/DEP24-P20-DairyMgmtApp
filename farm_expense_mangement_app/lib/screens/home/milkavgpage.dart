import 'package:flutter/material.dart';

class MilkData {
  final String rfid;
  final double milkInMorning;
  final double milkInEvening;


  MilkData({
    required this.rfid,
    required this.milkInMorning,
    required this.milkInEvening,

  });
}

class AvgMilkCowPage extends StatelessWidget {
  const AvgMilkCowPage({super.key});

  @override
  Widget build(BuildContext context) {


    final List<MilkData> milkData = [
      MilkData(rfid: "1", milkInMorning: 2.5, milkInEvening: 3.0, ),
      MilkData(rfid: "2", milkInMorning: 3.0, milkInEvening: 3.5, ),
      MilkData(rfid: "3", milkInMorning: 2.0, milkInEvening: 2.5,),
      MilkData(rfid: "4", milkInMorning: 4.0, milkInEvening: 2.5, ),
      MilkData(rfid: "5", milkInMorning: 4.5, milkInEvening: 3.6, ),
      MilkData(rfid: "6", milkInMorning: 5.0, milkInEvening: 1.7, ),
      MilkData(rfid: "7", milkInMorning: 1.6, milkInEvening: 3.8, ),
      MilkData(rfid: "8", milkInMorning: 2.4, milkInEvening: 4.6, ),
      MilkData(rfid: "8", milkInMorning: 2.4, milkInEvening: 4.6, ),
      MilkData(rfid: "8", milkInMorning: 2.4, milkInEvening: 4.6, ),
      MilkData(rfid: "8", milkInMorning: 2.4, milkInEvening: 4.6, ),
      MilkData(rfid: "8", milkInMorning: 2.4, milkInEvening: 4.6, ),
      MilkData(rfid: "9", milkInMorning: 2.4, milkInEvening: 4.6, ),
    ];



    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue[100],
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

        title: Center(child: Text('Milk Records')),
        actions: [
          IconButton(
            onPressed: () {
              // Handle search action
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              // Handle filter action
            },
            icon: Icon(Icons.filter_list),
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
        itemCount: milkData.length,
        itemBuilder: (context, index) {
          final data = milkData[index];
          return MilkDataRow(data: data);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add action
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMilkDataPage()),
          );
        },
          backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

        child: Icon(Icons.add),
      ),
    );
  }
}

class MilkDataRow extends StatelessWidget {
  final MilkData data;

  const MilkDataRow({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.blue[100],
      color: const Color.fromRGBO(242, 210, 189, 0.8),

      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8,13,8,13),
        child: Row(
          children: [
            Image.asset('asset/cow.jpg',width: 30,height: 35,),
            SizedBox(width: 10.0),
            Expanded(child: Text("RFID: ${data.rfid}"),flex: 1,),
            SizedBox(width: 10.0),
            Image.asset('asset/morning.webp',width: 30,height: 35,),
            Expanded(child: Text("${data.milkInMorning}L"),flex: 1,),

            Image.asset('asset/evening2.jpg',width: 25,height: 35,),
            Expanded(child: Text(" ${data.milkInEvening}L"),flex: 1,),

            SizedBox(width: 9.0),

            Expanded(child: Text("Total Milk: ${data.milkInEvening +data.milkInMorning}L"),flex: 2,),
          ],
        ),
      ),
    );
  }
}


class AddMilkDataPage extends StatefulWidget {
  @override
  _AddMilkDataPageState createState() => _AddMilkDataPageState();
}

class _AddMilkDataPageState extends State<AddMilkDataPage> {
  String? rfid;
  double? milkInMorning;
  double? milkInEvening;
  DateTime? milkingDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Milk Data'),
        // backgroundColor: Colors.blue[100],
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

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
                  decoration: InputDecoration(
                    labelText: 'RFID',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _buildInputBox(
                child: TextFormField(
                  onChanged: (value) {
                    milkInMorning = double.tryParse(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Morning Milk',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _buildInputBox(
                child: TextFormField(
                  onChanged: (value) {
                    milkInEvening = double.tryParse(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Evening Milk',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
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
                      decoration: InputDecoration(
                        labelText: 'Milking Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
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
                      MilkData newMilkData = MilkData(
                        rfid: rfid!,
                        milkInMorning: milkInMorning!,
                        milkInEvening: milkInEvening!,
                        // totalMilk: milkInMorning! + milkInEvening!,
                      );
                      // Here, you can add the new milk data to your list or database
                      Navigator.pop(context); // Close the add milk data page
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
      padding: EdgeInsets.fromLTRB(10, 2, 2, 2),
      child: child,
    );
  }
}
