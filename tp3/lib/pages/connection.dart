import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
