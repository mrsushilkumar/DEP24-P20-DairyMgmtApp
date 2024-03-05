import 'package:flutter/material.dart';

class AnimalList extends StatelessWidget {
  const AnimalList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Animals',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF39445A),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            // Implement back button functionality here
          },
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              // Implement search button functionality here
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5, // Assuming you have 5 cattle to display
        itemBuilder: (context, index) {
          // Assuming some data for demonstration
          String gender = index.isEven ? 'M' : 'F';
          String cattleId = 'RF ID: ${index + 1}';
          String birthDate = 'DOB : 2022-01-${index + 1}'; // Example date

          return Card(
            color: Colors.brown[100],
            child: ListTile(
              leading: gender == 'M'
                  ? Image.asset(
                'assets/cow.png', // Replace with your image asset for male
                width: 50,
                height: 50,
              )
                  : Image.asset(
                'assets/bull.png', // Replace with your image asset for female
                width: 50,
                height: 50,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cattleId,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(birthDate),
                ],
              ),

              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios_outlined),onPressed: () {
                // Implement the functionality when the arrow button is pressed
              },
              ),
              onTap: () {
                // Implement functionality when card is tapped
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Colors.brown[70],
        onPressed: () {
          // Implement functionality to add more cattle
        },
        tooltip: 'Add Cattle',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Filter Options',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildFilterOption('State:', ['Milked', 'Heifer', 'Insemination', 'Abortion', 'Dry', 'Calved']),
              SizedBox(height: 20),
              _buildFilterOption('Gender:', ['Bull', 'Cow']),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement confirm filters functionality here
                    },
                    child: Text('Confirm Filters'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement clear filters functionality here
                    },
                    child: Text('Clear Filters'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _buildFilterOption(String title, List<String> options) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey[300]), // Adding border
        borderRadius: BorderRadius.circular(8.0), // Adding border radius
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Changing text color
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              return FilterChip(
                label: Text(option),
                onSelected: (isSelected) {
                  // Handle chip selection
                },
                selectedColor: Colors.blue, // Changing chip color
                selected: false, // Setting initial selection state
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

}

