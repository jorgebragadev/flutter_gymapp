import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gymapp/_common/my_colors.dart';
import 'package:flutter_gymapp/componets/show_add_edit_sentiment_modal.dart';
import 'package:flutter_gymapp/models/exercise_model.dart';
import 'package:flutter_gymapp/models/feeling_model.dart';
import 'package:flutter_gymapp/services/service_feeling.dart';

class SreenExercise extends StatelessWidget {
  final ExerciseModel exerciseModel;
  SreenExercise({super.key, required this.exerciseModel});

  ServiceFeelig _serviceFeelig = ServiceFeelig();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Column(children: [
            Text(
              exerciseModel.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            ),
            Text(
              exerciseModel.treino,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ]),
          centerTitle: true,
          backgroundColor: MyColors.DarkBlue,
          elevation: 0,
          toolbarHeight: 72,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddEditSentimentDialog(
              context,
              idExercise: exerciseModel.id,
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Enviar Foto"),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Tirar Foto"),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Como fazer?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(exerciseModel.comoFazer),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              const Text(
                "Como estou me sentindo?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<FeelingModel>>(
                stream:
                    _serviceFeelig.conectarStream(idExercise: exerciseModel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return SizedBox(
                        height: 400, // Altura fixa para a lista
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            FeelingModel feelingNow = snapshot.data![index];
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(feelingNow.sentindo),
                              subtitle: Text(feelingNow.data),
                              leading: const Icon(Icons.double_arrow),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showAddEditSentimentDialog(
                                        context,
                                        idExercise: exerciseModel.id,
                                        feelingModel: feelingNow,
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      _serviceFeelig.removeFeeling(
                                        exerciseId: exerciseModel.id,
                                        feelingId: feelingNow.id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      print("Nenhum dado disponível.");
                      return Center(
                        child: Text(
                            "Nenhuma anotação de sentimento para este exercício"),
                      );
                    }
                  }
                },
              )
            ],
          ),
        ));
  }
}
