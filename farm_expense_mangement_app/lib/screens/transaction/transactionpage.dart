import 'package:farm_expense_mangement_app/models/transaction.dart';
import 'package:farm_expense_mangement_app/services/database/transactiondatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'expenses.dart';
import 'income.dart';

class TransactionPage extends StatefulWidget {
  final bool showIncome; // New parameter
  const TransactionPage({Key? key, required this.showIncome}) : super(key: key);

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
  List<Expense> expenseTransactions = [];

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Future<void> _fetchIncome() async {
    final snapshot = await dbSale.infoFromServerAllTransaction();
    setState(() {
      incomeTransactions = snapshot.docs
          .map((doc) => Sale.fromFireStore(doc, null))
          .where((sale) =>
      (selectedStartDate == null ||
          sale.saleOnMonth!.isAfter(selectedStartDate!)) &&
          (selectedEndDate == null ||
              sale.saleOnMonth!.isBefore(selectedEndDate!)))
          .toList();
    });
  }

  Future<void> _fetchExpense() async {
    final snapshot = await dbExpanse.infoFromServerAllTransaction();
    setState(() {
      expenseTransactions = snapshot.docs
          .map((doc) => Expense.fromFireStore(doc, null))
          .where((expense) =>
      (selectedStartDate == null ||
          expense.expenseOnMonth!.isAfter(selectedStartDate!)) &&
          (selectedEndDate == null ||
              expense.expenseOnMonth!.isBefore(selectedEndDate!)))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    dbSale = DatabaseForSale(uid: uid);
    dbExpanse = DatabaseForExpanse(uid: uid);
    showIncome = widget.showIncome; // Set showIncome based on the parameter
    _fetchIncome();
    _fetchExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 152, 186, 1.0),
        title: const Text(
          'Transactions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list_outlined,
              color: Colors.black,
            ),
            onPressed: () async {
              await _showDateRangePicker(context);
              setState(() {});
            },
          ),
          Visibility(
            visible: selectedStartDate != null || selectedEndDate != null,
            child: IconButton(
              icon: const Icon(Icons.clear,
              color: Colors.black,),
              onPressed: () {
                setState(() {
                  selectedStartDate = null;
                  selectedEndDate = null;
                  _fetchIncome();
                  _fetchExpense();
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
                            ? Colors.blueGrey[100]
                            : const Color.fromRGBO(240, 255, 255, 0.9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        boxShadow: showIncome
                            ? [BoxShadow(color: Colors.grey.withOpacity(1), blurRadius: 4)]
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
                            ? const Color.fromRGBO(240, 255, 255, 0.9)
                            : Colors.blueGrey[100],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        boxShadow: showIncome ? [] : [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4)],
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (showIncome)
                  ? AddIncome(
                onSubmit: () {
                  _fetchIncome();
                  _fetchExpense();
                },
              )
                  : AddExpenses(
                onSubmit: () {
                  _fetchIncome();
                  _fetchExpense();
                },
              ),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1),
        tooltip: 'Add Transaction',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

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
      _fetchIncome();
      _fetchExpense();
    }
  }
}

class ListTileForSale extends StatefulWidget {
  final List<Sale> data;
  const ListTileForSale({Key? key, required this.data}) : super(key: key);

  @override
  State<ListTileForSale> createState() => _ListTileForSaleState();
}

class _ListTileForSaleState extends State<ListTileForSale> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final sale = widget.data[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 2),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.green.shade500.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(
                sale.name,
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Amount:  ${sale.value.toStringAsFixed(2)}| On Date: ${sale.saleOnMonth?.day}-${sale.saleOnMonth?.month}-${sale.saleOnMonth?.year}',
                style:  TextStyle(color: Colors.grey[800]),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ListTileForExpense extends StatefulWidget {
  final List<Expense> data;
  const ListTileForExpense({Key? key, required this.data}) : super(key: key);

  @override
  State<ListTileForExpense> createState() => _ListTileForExpenseState();
}

class _ListTileForExpenseState extends State<ListTileForExpense> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final expense = widget.data[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 2),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.red.shade500.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(
                expense.name,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Amount:  ${expense.value.toStringAsFixed(2)}| On Date: ${expense.expenseOnMonth?.day}-${expense.expenseOnMonth?.month}-${expense.expenseOnMonth?.year}',
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
          ),
        );
      },
    );
  }
}
