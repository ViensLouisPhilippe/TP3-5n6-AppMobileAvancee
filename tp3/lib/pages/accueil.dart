import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigationBar.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(),
      body: const Center(
        child: Column(
          children: [
            Text(
                "j'ai réussi"
            ),
            Text("bravo")
          ],
        ),
      ),
    );
  }

}