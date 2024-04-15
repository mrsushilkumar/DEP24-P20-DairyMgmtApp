import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'income.dart';
import 'expenses.dart';

class Transaction {
  final String category;
  final double amount;
  final DateTime date;

  Transaction({required this.category, required this.amount, required this.date});
}

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool showIncome = true;
  List<Transaction> incomeTransactions = [
    Transaction(category: 'Milk Sale', amount: 100.0, date: DateTime(2024, 4, 13),),
    Transaction(category: 'Cattle Sale', amount: 200.0, date: DateTime(2024, 10, 5)),
    Transaction(category: 'Milk Sale', amount: 300.0, date: DateTime(2023,12,11)),
    // Add more income transactions as needed
  ];
  List<Transaction> expenseTransactions =[
    Transaction(category: 'Feed', amount: 100.0, date: DateTime(2022,12,6)),
    Transaction(category: 'Veterinary', amount: 200.0, date: DateTime(2023,6,19)),
    Transaction(category: 'Labor Costs', amount: 300.0, date: DateTime(2024,4,8)),
    Transaction(category: 'Equipment and Machinery', amount: 300.0, date: DateTime(2024,4,8)),
    // Add more income transactions as needed
  ];
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  // Function to filter transactions based on the selected date range
  List<Transaction> filterTransactionsByDate(List<Transaction> transactions) {
    if (selectedStartDate == null || selectedEndDate == null) {
      return transactions;
    }
    return transactions.where((transaction) {
      return transaction.date.isAfter(selectedStartDate!) && transaction.date.isBefore(selectedEndDate!);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> currentTransactions = showIncome ? incomeTransactions : expenseTransactions;
    currentTransactions = filterTransactionsByDate(currentTransactions);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 152, 186, 1.0),
        title: Text('Transactions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            icon: Icon(Icons.filter_list_outlined),
            onPressed: () async {
              await _showDateRangePicker(context);
              setState(() {});
            },
          ),
        Visibility(
          visible: selectedStartDate != null || selectedEndDate != null,
            child:  IconButton(
              icon: Icon(Icons.clear),
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
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: showIncome ? Colors.blue[200] : Colors.blueGrey[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        boxShadow: showIncome ? [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4)] : [],
                      ),
                      child: Center(
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
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: showIncome ? Colors.blueGrey[100] : Colors.blue[200],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        boxShadow: showIncome ? [] : [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4)],
                      ),
                      child: Center(
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
            child: ListView.builder(
              itemCount: currentTransactions.length,
              itemBuilder: (context, index) {
                // Get the current transaction
                Transaction transaction = currentTransactions[index];

                // Define a color based on the transaction type (income or expense)
                Color tileColor = showIncome ? Colors.green.shade500 : Colors.red.shade300;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: tileColor.withOpacity(0.2), // Set background color with opacity
                      borderRadius: BorderRadius.circular(8.0), // Add border radius for rounded corners
                    ),
                    child: ListTile(
                      title: Text(
                        transaction.category,
                        style: TextStyle(
                          color: tileColor, // Set text color to match background color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Amount: ${transaction.amount.toString()} | Date: ${DateFormat.yMd().format(transaction.date)}',
                        style: TextStyle(
                          color: Colors.grey[800], // Set text color for subtitle
                        ),
                      ),
                      // Customize this with your actual transaction data
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _showAddTransactionDialog(context);
          Navigator.push(
            context,
           MaterialPageRoute(builder: (context) => showIncome? AddIncome() : AddExpenses()),
          );
        },
        tooltip: 'Add Transaction',
        child: Icon(Icons.add),
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
