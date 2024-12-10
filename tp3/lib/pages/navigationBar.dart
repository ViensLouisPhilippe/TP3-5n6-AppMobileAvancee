import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tp3/pages/createTask.dart';

import 'accueil.dart';
import 'connexion.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  // Load username after user is authenticated
  Future<String> _loadUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ?? "Guest";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<String>(
            future: _loadUsername(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
                  accountName: Text("Loading..."),
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                );
              } else if (snapshot.hasError) {
                return const UserAccountsDrawerHeader(
                  accountName: Text("Error"),
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.error),
                  ),
                );
              } else {
                return UserAccountsDrawerHeader(
                  accountName: Text(snapshot.data ?? "Guest"),
                  accountEmail: const Text(''),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://tmssl.akamaized.net//images/foto/galerie/lionel-messi-argentinien-2022-1698689902-120754.jpg?lm=1698689910',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpn1HdAxEkkXu52D7NKjnhnNIoUBWSXy1muw&s',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          ),
          // Home
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Accueil(),
                ),
              );
            },
          ),
          // Create Task
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Create task"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Create(),
                ),
              );
            },
          ),
          // Logout
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("log out"),
            onTap: () async {
              try {
                print('Logging out');
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Connexion(),
                  ),
                      (Route<dynamic> route) => false,
                );
              } catch (e) {
                print("Error logging out: $e");
              }
            },
          ),
        ],
      ),
    );
  }
}
