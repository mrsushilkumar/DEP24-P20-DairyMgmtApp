import 'package:farm_expense_mangement_app/screens/feed/feedpage.dart';
import 'package:flutter/material.dart';
import 'package:farm_expense_mangement_app/models/feed.dart';
import 'package:farm_expense_mangement_app/services/database/feeddatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFeedItem extends StatefulWidget {
  const AddFeedItem({super.key});
// const AddFeedItem({Key? key}) : super(key: key);

  @override
  State<AddFeedItem> createState() => _AddFeedItemState();
// _AddFeedItemState createState() => _AddFeedItemState();
}

class _AddFeedItemState extends State<AddFeedItem> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _requiredQuantityController =
      TextEditingController();
  late final DatabaseServicesForFeed cattleDb;
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  void _saveFeedItem(BuildContext context) {
    String itemName = _itemNameController.text.trim();
    int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    int requiredQuantity =
        int.tryParse(_requiredQuantityController.text.trim()) ?? 0;

    Feed newFeedItem = Feed(
      itemName: itemName,
      quantity: quantity,
      requiredQuantity: requiredQuantity,

    );

// Now you can save this newFeedItem to Firestore or perform any other actions here
// For example, you can use the DatabaseServicesForFeed to save the feed item
// DatabaseServicesForFeed(itemName).infoToServerFeed(newFeedItem);
    cattleDb.infoToServerFeed(newFeedItem);

// After saving, you can navigate back to the previous screen
// Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const FeedPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Add Feed Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _requiredQuantityController,
              decoration: const InputDecoration(labelText: 'Required Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveFeedItem(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
// title: Text('Add Feed Item'),
      ),
    );
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();

    cattleDb = DatabaseServicesForFeed(uid);
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _requiredQuantityController.dispose();
    super.dispose();
  }
}
