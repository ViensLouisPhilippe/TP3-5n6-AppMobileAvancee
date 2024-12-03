import 'package:cloud_firestore/cloud_firestore.dart';


class Task{
  String id = "";
  String name = "";
  DateTime timeSpent = DateTime.now();
  DateTime deadline = DateTime.now();
  int progres = 0;
  String photoUrl = "";
  Task();

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "deadline": deadline,
      "progres": progres,
      "timeSpent":timeSpent,
      "photoUrl": photoUrl
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
    resultat.progres = data?["progres"].toDate();
    resultat.timeSpent = data?["timeSpent"];
    resultat.photoUrl = data?["photoUrl"];
    return resultat;
  }
}