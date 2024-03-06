
import 'package:flutter/material.dart';

import '../../models/cattle.dart';

class AnimalDetails extends StatefulWidget {

  final Cattle cattle;
  const AnimalDetails({super.key,required this.cattle});

  @override
  State<AnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.cattle.rfid,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              )
          ),
          IconButton(
              onPressed: () {

              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              )
          ),
          IconButton(
              onPressed: () {

              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              )
          )
        ],
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: Colors.grey.shade500,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Text(
                      "${widget.cattle.age}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Age",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: Colors.grey.shade500,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Text(
                      widget.cattle.sex,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Gender",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: Colors.grey.shade500,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Text(
                      "${widget.cattle.weight}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Weight",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: Colors.grey.shade500,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Text(
                      widget.cattle.breed,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Breed",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: Colors.grey.shade500,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Text(
                      "${widget.cattle.lactationCycle}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Lactation\nCycle",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
