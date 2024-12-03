import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigationBar.dart';

class Consultation extends StatefulWidget {
  final String id;
  const Consultation({required this.id});

  @override
  _ConsultationState createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {

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
