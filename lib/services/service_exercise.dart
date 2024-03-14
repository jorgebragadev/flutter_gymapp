import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gymapp/models/exercise_model.dart';

class ServiceExercise {
  String userId;
  ServiceExercise() : userId = FirebaseAuth.instance.currentUser!.uid;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExercise(ExerciseModel exerciseModel) async {
    return await _firestore
        .collection(userId)
        .doc(exerciseModel.id)
        .set(exerciseModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectExerciseStream(
      bool isDecrescente) {
    return _firestore
        .collection(userId)
        .orderBy("treino", descending: isDecrescente)
        .snapshots();
  }

  Future<void> removeExercise({required String idExercise}) {
    return _firestore.collection(userId).doc(idExercise).delete();
  }
}
