import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigationBar.dart';

class Reussipage extends StatefulWidget {
  const Reussipage({super.key});

  @override
  _ReussipageState createState() => _ReussipageState();
}

class _ReussipageState extends State<Reussipage> {

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
