import 'package:flutter/material.dart';

// Define a data model for feed items
class FeedItem {
  final String name;
  int currentStock;
  int need;

  FeedItem({
    required this.name,
    required this.currentStock,
    required this.need,
  });
}

class FeedSection extends StatefulWidget {
  const FeedSection({Key? key}) : super(key: key);

  @override
  State<FeedSection> createState() => _FeedSectionState();

}

class _FeedSectionState extends State<FeedSection> {
  // Example list of feed items
  List<FeedItem> feedItems = [
    FeedItem(name: 'Feed Item 1', currentStock: 50, need: 20),
    FeedItem(name: 'Feed Item 2', currentStock: 30, need: 10),
    FeedItem(name: 'Feed Item 3', currentStock: 40, need: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed Section'),
      ),
      body: ListView.builder(
        itemCount: feedItems.length,
        itemBuilder: (context, index) {
          FeedItem feedItem = feedItems[index];
          return ListTile(
            title: Text(feedItem.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Stock: ${feedItem.currentStock}'),
                Text('Need: ${feedItem.need}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editFeedItem(feedItem);
              },
            ),
          );
        },
      ),
    );
  }

  // Function to edit feed item
  void _editFeedItem(FeedItem feedItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController currentStockController =
        TextEditingController(text: feedItem.currentStock.toString());
        TextEditingController needController =
        TextEditingController(text: feedItem.need.toString());

        return AlertDialog(
          title: Text('Edit Feed Item: ${feedItem.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentStockController,
                decoration: InputDecoration(labelText: 'Current Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: needController,
                decoration: InputDecoration(labelText: 'Need'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                int currentStock =
                    int.tryParse(currentStockController.text) ?? 0;
                int need = int.tryParse(needController.text) ?? 0;
                setState(() {
                  feedItem.currentStock = currentStock;
                  feedItem.need = need;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
