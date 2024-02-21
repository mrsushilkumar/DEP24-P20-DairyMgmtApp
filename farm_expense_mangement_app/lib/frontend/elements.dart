import 'package:farm_expense_mangement_app/backend/cattle.dart';
import 'package:flutter/material.dart';

// Card for the each Cattle
class CattleCard extends StatefulWidget {
  const CattleCard({super.key, required this.cattle});

  final String cattle;

  @override
  State<CattleCard> createState() => _CattleCardState();
}

class _CattleCardState extends State<CattleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Card(
            elevation: 16,
            color: Colors.blueAccent.shade100,
            shadowColor: Colors.black,
            surfaceTintColor: Colors.white10,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(16, 24))),
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Center(
                        child: Text(
                          widget.cattle,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward)
                        ),
                      ),
                    )
                ]
              ),
            )
        ),
      ),
    );
  }
}

class CattleView extends StatefulWidget {
  const CattleView({super.key, required this.listCattle});

  final List<String> listCattle;

  @override
  State<CattleView> createState() => _CattleViewState();
}

class _CattleViewState extends State<CattleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: "Menu",
          color: Colors.blueAccent,
          focusColor: Colors.black54,
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          "Cattle List",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 32, color: Colors.blue),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.listCattle.length,
          itemBuilder: (BuildContext context, int index) {
            return CattleCard(cattle: widget.listCattle[index]);
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

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
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
            onPressed: (){

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
                  "Lactation Cycle",
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
