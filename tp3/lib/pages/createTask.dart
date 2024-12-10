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
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  Future<bool> _isTaskNameDuplicate(String trimmedName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return false;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Tasks")
        .where("name", isEqualTo: trimmedName)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> _submitTask() async {
    final trimmedName = _nameController.text.trim();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (trimmedName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task name cannot be empty or whitespace only.")),
      );
      return;
    }

    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a due date.")),
      );
      return;
    }

    if (_dueDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The due date must be in the future.")),
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

      final isDuplicate = await _isTaskNameDuplicate(trimmedName);
      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("A task with this name already exists.")),
        );
        return;
      }

      // Ajouter la tâche à Firebase
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Tasks")
          .add({
        "name": trimmedName,
        "deadline": _dueDate!.toIso8601String(),
        "progres": 0,
        "timeSpent": 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task successfully added!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Accueil()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error while adding task: $e")),
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
        title: const Text("Create task"),
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
                    decoration: const InputDecoration(
                      labelText: "Task name",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Task name cannot be empty.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _dueDate == null
                        ? "Select a due date"
                        : 'Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate!)}',
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _selectDueDate,
                    child: const Text("Pick Date"),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: _submitTask,
                    child: const Text("Add Task"),
                  ),
                  ElevatedButton(
                    child: const Text("Go Back"),
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
