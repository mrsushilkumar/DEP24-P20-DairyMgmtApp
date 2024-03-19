

import 'package:flutter/material.dart';

class AddFeedItem extends StatefulWidget {
  const AddFeedItem({super.key});

  @override
  State<AddFeedItem> createState() => _AddFeedItemState();
}

class _AddFeedItemState extends State<AddFeedItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)
        ),
        title: Text('Add Feed Item'),
      ),
    );
  }
}
