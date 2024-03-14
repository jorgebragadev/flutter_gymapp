import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gymapp/models/feeling_model.dart';

class ServiceFeelig {
  String userId;
  ServiceFeelig() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String key = "feelings";

  Future<void> addFeeling({
    required String idExercise,
    required FeelingModel feelingModel,
  }) async {
    return await _firestore
        .collection(userId)
        .doc(idExercise)
        .collection(key)
        .doc(feelingModel.id)
        .set(feelingModel.toMap());
  }

  Stream<List<FeelingModel>> conectarStream({required String idExercise}) {
    return _firestore
        .collection(userId) // Use a coleção do usuário
        .doc(idExercise) // Adicione o documento específico do exercício
        .collection(key) // Coleção de sentimentos
        .orderBy("data", descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return <FeelingModel>[]; // Retorna uma lista vazia se não houver dados
      } else {
        print(
            'Dados disponíveis: ${snapshot.docs.length} documentos'); // Verificando o número de documentos

        // Mapeia os documentos do Firestore para objetos FeelingModel
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return FeelingModel(
            id: doc.id, // Define o ID do sentimento como o ID do documento
            sentindo: data['sentindo'],
            data: data['data'],
          );
        }).toList();
      }
    });
  }

  Future<void> removeFeeling(
      {required String exerciseId, required String feelingId}) async {
    return await _firestore
        .collection(userId)
        .doc(exerciseId)
        .collection(key)
        .doc(feelingId)
        .delete();
  }
}
