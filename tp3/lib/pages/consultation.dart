import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'accueil.dart';
import 'navigationBar.dart';

class Consultation extends StatefulWidget {
  final String taskId;

  const Consultation({required this.taskId, Key? key}) : super(key: key);

  @override
  _ConsultationState createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  double _currentSliderValue = 0;
  bool isLoading = true;
  bool _isUpdating = false;

  DocumentSnapshot? task;
  String? userId;

  Future<void> getTaskDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("Utilisateur non connecté");
      }

      final taskSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Tasks")
          .doc(widget.taskId)
          .get();

      if (taskSnapshot.exists) {
        setState(() {
          task = taskSnapshot;
          _currentSliderValue = task!["progres"].toDouble();
          isLoading = false;
        });
      } else {
        throw Exception("Tâche introuvable");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProgress() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Tasks")
          .doc(widget.taskId)
          .update({"progres": _currentSliderValue.toInt()});

      await getTaskDetails(); // Rafraîchir les données après mise à jour
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour: $e")),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future<void> deleteTask({bool hardDelete = false}) async {
    setState(() {
      _isUpdating = true;
    });

    try {
        // Suppression définitive
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("Tasks")
            .doc(widget.taskId)
            .delete();


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "delete successful"
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Accueil()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression: $e")),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTaskDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: Text("Task detail"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (task == null) {
      return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: Text("Task detail"),
        ),
        body: Center(
          child: Text("task not found"),
        ),
      );
    }

    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: Text("Task detail"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${"task name"}${task!["name"]}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '${"deadline"}${task!["deadline"]}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  '${"completion pourcentage"}${_currentSliderValue.toInt()}%',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: _currentSliderValue,
                  max: 100,
                  divisions: 100,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateProgress,
                  child: Text("update progress"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => deleteTask(hardDelete: true),
                  child: Text("delete"),
                ),
                ElevatedButton(
                  child: Text("go back"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Accueil(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (_isUpdating)
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
