import 'package:flutter/material.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountTextController = TextEditingController();



  final TextEditingController _DateController = TextEditingController();
  String? _selectedCategory;

  final List<String> sourceOptions = [
    'Feed',
    'Veterinary',
    'Labor Costs',
    'Equipment and Machinery'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked.day.toString() != _DateController.text) {
      setState(() {
        _DateController.text = picked.toString().split(' ')[0];
      });
    }
  }


  @override


  @override
  void dispose() {

    _DateController.dispose();
    _amountTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Transaction',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
             },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
          child: Column(
            children: [
              Text("Expenses",style: TextStyle(fontSize: 25,color: Colors.blueGrey),),

              SizedBox(height: 25,),

              Form(
                key: _formKey,
                child: Column(
                    children: [


                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: TextFormField(
                          controller: _DateController,
                          decoration: InputDecoration(
                            labelText: ' Date of expense ',
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
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _amountTextController,
                          decoration: InputDecoration(
                            labelText: 'How much did you spend (in ₹)?',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      // SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Select expense type*',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          items: sourceOptions.map((String source) {
                            return DropdownMenuItem<String>(
                              value: source,
                              child: Text(source),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },

                        ),
                      ),



                      // SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Submit",),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          minimumSize: Size(120, 50),
                          backgroundColor: Color.fromRGBO(13, 166, 186, 1.0),
                          foregroundColor: Colors.white,
                          elevation: 10, // adjust elevation value as desired
                          side: BorderSide(color: Colors.grey, width: 2),
                        ),

                      )


                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}