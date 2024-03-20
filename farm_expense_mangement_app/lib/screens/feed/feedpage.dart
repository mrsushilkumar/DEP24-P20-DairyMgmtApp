import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/models/feed.dart';
import 'package:farm_expense_mangement_app/screens/feed/addfeeditem.dart';
import 'package:farm_expense_mangement_app/services/database/feeddatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class FeedItem {
//   final String name;
//   int currentStock;
//   int need;
//
//   FeedItem({
//     required this.name,
//     required this.currentStock,
//     required this.need,
//   });
// }

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

  // Future<void> _fetchFeed() async {
  //   final snapshot = await feedDb.infoFromServerAllFeed(uid);
  //   setState(() {
  //     allFeed =
  //         snapshot.docs.map((doc) => Feed.fromFireStore(doc, null)).toList();
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedDb = DatabaseServicesForFeed(uid);

    _streamController = feedDb.infoFromServerAllFeed(uid).asStream();
    // _fetchFeed();
  }

  @override
  Widget build(BuildContext context) {

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
            }
            else if (snapshot.hasData) {
              allFeed = snapshot.requireData.docs.map((value) => Feed.fromFireStore(value,null)).toList();
              return ListView.builder(
                itemCount: allFeed.length,
                itemBuilder: (context, index) {
                  Feed feedItem = allFeed[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FeedDetail(feedItem: feedItem,)));
                      });
                    },
                    child: Card(
                      // color: Colors.orange[100],
                      color: Colors.blue[100],
                      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      surfaceTintColor: Colors.lightBlue[100],
                      shadowColor: Colors.lightBlue[100],
                      elevation: 4,
                      child: ListTile(
                        title: Text(feedItem.itemName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current Stock: ${feedItem.quantity}'),
                            Text('Need: ${feedItem.requiredQuantity}'),
                          ],
                        ),
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

}

class FeedDetail extends StatefulWidget {
  final Feed feedItem;
  const FeedDetail({super.key,required this.feedItem});

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Detail'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            // Navigator.pop(context);
            
          },
        ),
      ),
    );
  }


  void _editFeedItem(Feed feedItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController currentStockController =
        TextEditingController(text: feedItem.requiredQuantity.toString());
        TextEditingController needController =
        TextEditingController(text: feedItem.requiredQuantity.toString());

        return AlertDialog(
          title: Text('Edit Feed Item: ${feedItem.itemName}'),
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
                  feedItem.quantity = currentStock;
                  feedItem.requiredQuantity = need;
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
