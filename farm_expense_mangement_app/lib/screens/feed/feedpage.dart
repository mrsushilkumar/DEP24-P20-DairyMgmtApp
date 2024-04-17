import 'package:flutter/material.dart';
import 'package:farm_expense_mangement_app/models/feed.dart';
import 'package:farm_expense_mangement_app/screens/feed/addfeeditem.dart';
import 'package:farm_expense_mangement_app/services/database/feeddatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:farm_expense_mangement_app/screens/feed/editfeeditem.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key,});

  @override
  State<FeedPage> createState() => _FeedState();
}

class _FeedState extends State<FeedPage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseServicesForFeed feedDb;
  late List<Feed> allFeed = [];
  late final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    feedDb = DatabaseServicesForFeed(uid);
    _fetchFeed();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchFeed() async {
    final snapshot = await feedDb.infoFromServerAllFeed();
    setState(() {
      allFeed = snapshot.docs.map((doc) => Feed.fromFireStore(doc, null)).toList();
    });
  }

  void editFeedDetail(Feed feed) {
    // Implement your logic to view feed detail
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFeedItemPage(feed: feed, uid: uid),
      ),
    );
  }

  void addFeed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFeedItem()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Feed> filteredFeed = allFeed;

    if (_searchController.text.isNotEmpty) {
      filteredFeed = filteredFeed.where((feed) =>
          feed.itemName.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }

    // Check for expiry date and set current stock to 0 if expired
    final currentDate = DateTime.now();
    for (var feed in filteredFeed) {
      if (feed.expiryDate != null && currentDate.isAfter(feed.expiryDate!)) {
        feed.quantity = 0;
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Feeds',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FeedSearchDelegate(allFeed, editFeedDetail), // Pass editFeedDetail function
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredFeed.length,
        itemBuilder: (context, index) {
          final feedInfo = filteredFeed[index];
          return FeedListItem(
            feed: feedInfo,
            onTap: () {
              // viewFeedDetail(feedInfo);
            },
            onEdit: () {
              // Implement your edit logic here
              editFeedDetail(feedInfo);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addFeed(context);
        },
        tooltip: 'Add Feed',
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FeedListItem extends StatefulWidget {
  final Feed feed;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const FeedListItem({super.key,
    required this.feed,
    required this.onTap,
    required this.onEdit,

  });

  @override
  State<FeedListItem> createState() => _FeedListItemState();
}

class _FeedListItemState extends State<FeedListItem> {
  @override
  Widget build(BuildContext context) {
    final bool isExpired = widget.feed.expiryDate != null &&
        DateTime.now().isAfter(widget.feed.expiryDate!);

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 8, // Add elevation for shadow
        color: const Color.fromRGBO(
            240, 255, 255, 1),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      // Add margins
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Add rounded corners
          side: const BorderSide(
            color: Colors.white,
            width: 3,
          ), // Add boundary color
        ),
        child: ListTile(
          title: Text(
            widget.feed.itemName,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isExpired ? Icons.warning : Icons.calendar_today,
                        color: isExpired ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Expiry Date: ${DateFormat('yyyy-MM-dd').format(widget.feed.expiryDate!)}',
                        style: TextStyle(color: isExpired ? Colors.orange[700]: Colors.green[700]),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: widget.onEdit,
                  ),
                ],
              ),
              Text(
                'Current Stock: ${widget.feed.quantity}',
                style: const TextStyle(color: Colors.black),
              ),
              Text(
                'Need: ${widget.feed.requiredQuantity}',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedSearchDelegate extends SearchDelegate<Feed> {
  final List<Feed> allFeed;
  final Function(Feed) editFeedDetail; // Callback function to handle edit functionality

  FeedSearchDelegate(this.allFeed, this.editFeedDetail);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, query.isEmpty ? Feed(itemName: '', category: '', quantity: 10) : Feed(itemName: '', category: '', quantity: 10));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = query.isEmpty
        ? allFeed
        : allFeed
        .where((feed) => feed.itemName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final feedInfo = searchResults[index];
        return FeedListItem(
          feed: feedInfo,
          onTap: () {
            close(context, feedInfo);
          },
          onEdit: () {
            // Call the callback function to handle edit functionality
            editFeedDetail(feedInfo);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = query.isEmpty
        ? allFeed
        : allFeed
        .where((feed) => feed.itemName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final feedInfo = searchResults[index];
        return FeedListItem(
          feed: feedInfo,
          onTap: () {
            close(context, feedInfo);
          },
          onEdit: () {
            // Call the callback function to handle edit functionality
            editFeedDetail(feedInfo);
          },
        );
      },
    );
  }
}
