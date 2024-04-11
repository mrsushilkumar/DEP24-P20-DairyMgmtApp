import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_expense_mangement_app/models/feed.dart';

class EditFeedItemPage extends StatefulWidget {
  final Feed feed;

  const EditFeedItemPage({Key? key, required this.feed}) : super(key: key);

  @override
  _EditFeedItemPageState createState() => _EditFeedItemPageState();
}

class _EditFeedItemPageState extends State<EditFeedItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _categoryController;
  late TextEditingController _needController;
  late TextEditingController _stockController;
  late DateTime _expiryDate;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.feed.itemName);
    _categoryController = TextEditingController(text: widget.feed.category);
    _needController = TextEditingController(text: widget.feed.requiredQuantity.toString());
    _stockController = TextEditingController(text: widget.feed.quantity.toString());
    _expiryDate = widget.feed.expiryDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _categoryController.dispose();
    _needController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, update the feed item
      final updatedFeed = Feed(
        itemName: _itemNameController.text,
        category: _categoryController.text,
        requiredQuantity: int.parse(_needController.text),
        quantity: int.parse(_stockController.text),
        expiryDate: _expiryDate,
      );

      // TODO: Implement logic to update feed item in database or wherever it's stored

      // Navigate back to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

        title: Text('Edit Feed Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),

                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _needController,
                  decoration: InputDecoration(labelText: 'Need'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter need';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text('Expiry Date: ${DateFormat('yyyy-MM-dd').format(_expiryDate)}'),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _expiryDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _expiryDate = selectedDate;
                      });
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(13, 166, 186, 0.9))

                ),

                child: Text('Save'
                ,style: TextStyle(
                    color: Colors.black
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
