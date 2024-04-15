import 'package:farm_expense_mangement_app/main.dart';
import 'package:farm_expense_mangement_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/database/userdatabase.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  final Color myColor = const Color(0xFF39445A);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      centerTitle: true,
      title: const Text(
        'Profile',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color.fromRGBO(13, 166, 186, 1.0),
      actions: [
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
          icon: const Icon(
            Icons.output_outlined,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProfilePage extends StatefulWidget implements PreferredSizeWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late FarmUser farmUser;
  late DatabaseServicesForUser userDb;

  @override
  void initState() {
    super.initState();
    userDb = DatabaseServicesForUser(uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userDb.infoFromServer(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          farmUser = FarmUser.fromFireStore(snapshot.requireData, null);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                ProfileInfoRow(
                  label: 'Farm Owner: ',
                  value: farmUser.ownerName,
                ),
                ProfileInfoRow(
                  label: 'Farm Name: ',
                  value: farmUser.farmName,
                ),
                ProfileInfoRow(
                  label: 'Email: ',
                  value: user!.email ?? "",
                ),
                ProfileInfoRow(
                  label: 'Phone Number: ',
                  value: '${farmUser.phoneNo}',
                ),
                ProfileInfoRow(
                  label: 'Address: ',
                  value: farmUser.location,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileEditPage(),
                      ),
                    );
                  },
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Error in Fetch'),
          );
        }
      },
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Name',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

