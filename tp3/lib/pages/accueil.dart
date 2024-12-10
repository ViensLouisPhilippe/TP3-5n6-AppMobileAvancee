import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../task.dart';
import 'consultation.dart';
import 'createTask.dart';
import 'navigationBar.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Task> tasks = [];
  bool isLoading = true;
  bool isError = false;
  String errorMessage = "";

  Future<void> getTasks() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        setState(() {
          isLoading = false;
          isError = true;
          errorMessage = "User not logged in";
        });
        return;
      }
      final taskQuerySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Tasks")
          .orderBy("name")
          .get();

      if (taskQuerySnapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
          tasks = [];
        });
        return;
      }
      setState(() {
        tasks = taskQuerySnapshot.docs.map((doc) {
          return Task.fromFirestore(doc);
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = "Failed to load tasks. Please try again.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await getTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (isError) {
      return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: Text("Task list"),  // Translated title
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Create(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getTasks,
                child: Text("try again"),  // Translated button text
              ),
            ],
          ),
        ),
      );
    }
    if (tasks.isEmpty) {
      return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: Text("Task List"),  // Translated title
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Create(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Text("no task found try again"),
        ),
      );
    }
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: Text("Task List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Create(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final Task task = tasks[index];

          return ListTile(
            title: Text(task.name),
            subtitle: Text(
              '${"progres"}: ${task.progres}% | ${"date due"}: ${task.timeSpent}%',
            ),
            trailing: Text(task.deadline),

            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Consultation(taskId: task.id,),
                ),
              );
            },

          );

        },
      ),
    );
  }
}