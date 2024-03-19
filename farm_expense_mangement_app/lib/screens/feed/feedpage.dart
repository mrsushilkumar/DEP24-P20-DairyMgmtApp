import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/models/feed.dart';
import 'package:farm_expense_mangement_app/screens/feed/addfeeditem.dart';
import 'package:farm_expense_mangement_app/services/database/feeddatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedState();
}

class _FeedState extends State<FeedPage> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _streamController;
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseServicesForFeed feedDb;
  late List<Feed> allFeed = [];

  Future<void> _fetchFeed() async {
    final snapshot = await feedDb.infoFromServerAllFeed(uid);
    setState(() {
      allFeed =
          snapshot.docs.map((doc) => Feed.fromFireStore(doc, null)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedDb = DatabaseServicesForFeed(uid);

    _streamController = feedDb.infoFromServerAllFeed(uid).asStream();
    _fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    List<FeedItem> feedItems = [
      FeedItem(name: 'Feed Item 1', currentStock: 50, need: 20),
      FeedItem(name: 'Feed Item 2', currentStock: 30, need: 10),
      FeedItem(name: 'Feed Item 3', currentStock: 40, need: 30),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[200],
        title: const Text('Feed Section'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFeedItem()));
          },
          backgroundColor: Colors.blue[100],
          focusElevation: 16,
          focusColor: Colors.lightBlue[200],
          child: const Icon(
            Icons.add,
          ),
      ),
      body: StreamBuilder(
          stream: _streamController,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('Loading'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: feedItems.length,
                itemBuilder: (context, index) {
                  FeedItem feedItem = feedItems[index];
                  return Card(
                    // color: Colors.orange[100],
                    color: Colors.blue[100],
                    margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    surfaceTintColor: Colors.lightBlue[100],
                    shadowColor: Colors.lightBlue[100],
                    elevation: 4,
                    child: ListTile(
                      title: Text(feedItem.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current Stock: ${feedItem.currentStock}'),
                          Text('Need: ${feedItem.need}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editFeedItem(feedItem);
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Error in Fetch'),
              );
            }
          }),
    );
  }

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
                decoration: const InputDecoration(labelText: 'Current Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: needController,
                decoration: const InputDecoration(labelText: 'Need'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
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
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

// class FeedCard extends StatefulWidget {
//   final int index;
//   final String info;
//   const FeedCard({super.key,required this.index,required this.info});
//
//   @override
//   State<FeedCard> createState() => _FeedCardState();
// }
//
// class _FeedCardState extends State<FeedCard> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
//       color: Colors.lightBlue[100],
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('${widget.index}'),
//             Text(widget.info)
//           ],
//         ),
//       ),
//     );
//   }
// }
