import 'package:cloud_firestore/cloud_firestore.dart';


class Task{
  String id = "";
  String name = "";
  int timeSpent = 0;
  String deadline = "";
  int progres = 0;
  Task();

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "deadline": deadline,
      "progres": progres,
      "timeSpent":timeSpent
    };
  }

  factory Task.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data();
    Task resultat = Task();
    resultat.id = snapshot.id;
    resultat.name  = data?["name"];
    resultat.deadline = data?["deadline"];
    resultat.progres = data?["progres"];
    resultat.timeSpent = data?["timeSpent"];
    return resultat;
  }
}