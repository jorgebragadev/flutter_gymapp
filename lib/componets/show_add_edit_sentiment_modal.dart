import 'package:flutter/material.dart';
import 'package:flutter_gymapp/models/feeling_model.dart';
import 'package:flutter_gymapp/services/service_feeling.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> showAddEditSentimentDialog(
  BuildContext context, {
  required String idExercise,
  FeelingModel? feelingModel,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController feelingController = TextEditingController();

      if (feelingModel != null) {
        feelingController.text = feelingModel.sentindo;
      }
      return AlertDialog(
        title: const Text("Como você esta se sentindo?"),
        content: TextFormField(
          controller: feelingController,
          decoration: const InputDecoration(
            label: Text("Diga como você esta se sentindo?"),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              FeelingModel feeling = FeelingModel(
                id: const Uuid().v1(),
                sentindo: feelingController.text,
                data: DateTime.now().toString(),
              );
              if (feelingModel != null) {
                feeling.id = feelingModel.id;
              }
              ServiceFeelig()
                  .addFeeling(idExercise: idExercise, feelingModel: feeling);
              Navigator.pop(context);
            },
            child: Text((feelingModel != null)
                ? "Editar Sentimento"
                : "Criar Sentimento"),
          ),
        ],
      );
    },
  );
}
