import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'accueil.dart';
import 'navigationBar.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _dueDate;
  bool _isLoading = false;

  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate() || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("non valide")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Ajouter la tâche à Firebase
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Tasks")
          .add({
        "name": _nameController.text,
        "deadline": _dueDate!.toIso8601String(),
        "progres": 0,
        "timeSpent":0
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("task added")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Accueil()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${"error while adding task"}: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: Text("Create task"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "task name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "empty value";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _dueDate == null
                        ? "select due date"
                        : '${"date"}: ${DateFormat('yyyy-MM-dd').format(_dueDate!)}',
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _selectDueDate,
                    child: Text("pick date"),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: _submitTask,
                    child: Text("add task"),
                  ),
                  ElevatedButton(
                    child: Text("go back"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
