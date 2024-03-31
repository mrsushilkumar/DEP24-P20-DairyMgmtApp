
import 'package:farm_expense_mangement_app/models/feed.dart';
import 'package:farm_expense_mangement_app/screens/feed/addfeeditem.dart';
import 'package:farm_expense_mangement_app/services/database/feeddatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

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
    final snapshot = await feedDb.infoFromServerAllFeed(uid);
    setState(() {
      allFeed = snapshot.docs.map((doc) => Feed.fromFireStore(doc, null)).toList();
    });
  }

  void viewFeedDetail(Feed feed) {
    // Implement your logic to view feed detail
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

    return Scaffold(
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
                delegate: FeedSearchDelegate(allFeed),
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
              viewFeedDetail(feedInfo);
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

  const FeedListItem({
    required this.feed,
    required this.onTap,
    super.key,
  });

  @override
  State<FeedListItem> createState() => _FeedListItemState();
}

class _FeedListItemState extends State<FeedListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        color: const Color.fromRGBO(242, 210, 189, 0.8), // Add background color
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        surfaceTintColor: Colors.lightBlue[100],
        shadowColor: Colors.white70,
        elevation: 8,
        child: ListTile(
          title: Text(widget.feed.itemName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Stock: ${widget.feed.quantity}'),
              Text('Need: ${widget.feed.requiredQuantity}'),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedSearchDelegate extends SearchDelegate<Feed> {
  final List<Feed> allFeed;

  FeedSearchDelegate(this.allFeed);

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
        close(context, query.isEmpty ? Feed(itemName: '', category: '',quantity: 10) : Feed(itemName: '', category: '',quantity: 10));
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
        );
      },
    );
  }
}
