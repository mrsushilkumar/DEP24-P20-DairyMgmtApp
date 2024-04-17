import 'package:farm_expense_mangement_app/models/transaction.dart';
import 'package:farm_expense_mangement_app/services/database/transactiondatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'expenses.dart';
import 'income.dart';

// class Transaction {
//   final String category;
//   final double amount;
//   final DateTime date;
//
//   Transaction({required this.category, required this.amount, required this.date});
// }

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseForSale dbSale;
  late DatabaseForExpanse dbExpanse;

  bool showIncome = true;
  List<Sale> incomeTransactions = [];
  List<Expense> expenseTransactions = [
    // Add more income transactions as needed
  ];

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  // Function to filter transactions based on the selected date range

  Future<void> _fetchIncome() async {
    final snapshot = await dbSale.infoFromServerAllTransaction();
    setState(() {
      incomeTransactions =
          snapshot.docs.map((doc) => Sale.fromFireStore(doc, null)).toList();
    });
  }

  Future<void> _fetchExpanse() async {
    final snapshot = await dbExpanse.infoFromServerAllTransaction();
    setState(() {
      expenseTransactions =
          snapshot.docs.map((doc) => Expense.fromFireStore(doc, null)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbSale = DatabaseForSale(uid: uid);
    dbExpanse = DatabaseForExpanse(uid: uid);
    _fetchIncome();
    _fetchExpanse();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 152, 186, 1.0),
        title: const Text('Transactions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {
          //     // Implement search functionality
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () async {
              await _showDateRangePicker(context);
              setState(() {});
            },
          ),
          Visibility(
            visible: selectedStartDate != null || selectedEndDate != null,
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  selectedStartDate = null;
                  selectedEndDate = null;
                });
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showIncome = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: showIncome
                            ? const Color.fromRGBO(240, 255, 255, 0.9)
                            : Colors.blueGrey[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        boxShadow: showIncome
                            ? [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 4)
                              ]
                            : [],
                      ),
                      child: const Center(
                        child: Text(
                          'Income',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showIncome = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: showIncome
                            ? Colors.blueGrey[100]
                            : const Color.fromRGBO(240, 255, 255, 0.9),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        boxShadow: showIncome
                            ? []
                            : [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 4)
                              ],
                      ),
                      child: const Center(
                        child: Text(
                          'Expenses',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: (showIncome)
                ? ListTileForSale(data: incomeTransactions)
                : ListTileForExpense(data: expenseTransactions),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _showAddTransactionDialog(context);
          if (showIncome) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddIncome(
                onSubmit: () {
                  print('add income');
                  _fetchIncome();
                  _fetchExpanse();
                },
              )
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpenses(
                onSubmit: (){
                  print('add expense');
                  _fetchExpanse();
                  _fetchIncome();
                },
              )),
            );
          }
        },
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

// Function to show date range picker
  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: selectedStartDate != null && selectedEndDate != null
          ? DateTimeRange(start: selectedStartDate!, end: selectedEndDate!)
          : null,
    );
    if (picked != null) {
      selectedStartDate = picked.start;
      selectedEndDate = picked.end;
    }
  }
}

class ListTileForSale extends StatefulWidget {
  final List<Sale> data;
  const ListTileForSale({super.key, required this.data});

  @override
  State<ListTileForSale> createState() => _ListTileForSaleState();
}

class _ListTileForSaleState extends State<ListTileForSale> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        // Define a color based on the transaction type (income or expense)
        Color tileColor = Colors.green.shade500;

        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: tileColor
                    .withOpacity(0.2), // Set background color with opacity
                borderRadius: BorderRadius.circular(
                    8.0), // Add border radius for rounded corners
              ),
              child: ListTile(
                title: Text(
                  widget.data[index].name,
                  style: TextStyle(
                    color: Colors.green
                        .shade500, // Set text color to match background color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Amount:  ${widget.data[index].value.toStringAsFixed(2)}| On Month: ${widget.data[index].saleOnMonth?.month}-${widget.data[index].saleOnMonth?.year}',
                  style: TextStyle(
                    color: Colors.grey[800], // Set text color for subtitle
                  ),
                ),
                // Customize this with your actual transaction data
              )),
        );
      },
    );
  }
}

class ListTileForExpense extends StatefulWidget {
  final List<Expense> data;
  const ListTileForExpense({super.key, required this.data});

  @override
  State<ListTileForExpense> createState() => _ListTileForExpenseState();
}

class _ListTileForExpenseState extends State<ListTileForExpense> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        // Define a color based on the transaction type (income or expense)
        Color tileColor = Colors.red.shade500;

        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: tileColor
                    .withOpacity(0.2), // Set background color with opacity
                borderRadius: BorderRadius.circular(
                    8.0), // Add border radius for rounded corners
              ),
              child: ListTile(
                title: Text(
                  widget.data[index].name,
                  style: TextStyle(
                    color: Colors.red
                        .shade300, // Set text color to match background color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Amount:  ${widget.data[index].value.toStringAsFixed(2)}| On Month: ${widget.data[index].expenseOnMonth?.month}-${widget.data[index].expenseOnMonth?.year}',
                  style: TextStyle(
                    color: Colors.grey[800], // Set text color for subtitle
                  ),
                ),
                // Customize this with your actual transaction data
              )),
        );
      },
    );
  }
}
