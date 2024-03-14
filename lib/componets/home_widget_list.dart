import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gymapp/componets/show_add_edit_exercise_modal.dart';
import 'package:flutter_gymapp/_common/my_colors.dart';
import 'package:flutter_gymapp/models/exercise_model.dart';
import 'package:flutter_gymapp/screens/screen_exercise.dart';
import 'package:flutter_gymapp/services/service_exercise.dart';

// ignore: camel_case_types
class startItemList extends StatelessWidget {
  final ExerciseModel exerciseModel;
  final ServiceExercise service;
  const startItemList(
      {super.key, required this.exerciseModel, required this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SreenExercise(exerciseModel: exerciseModel),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black.withAlpha(125),
              spreadRadius: 1,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: MyColors.DarkBlue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
                height: 30,
                width: 150,
                child: Center(
                  child: Text(
                    exerciseModel.treino,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          exerciseModel.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: MyColors.DarkBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showAddEditExerciseModal(context,
                                  exercise: exerciseModel);
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Deseja remover ${exerciseModel.name}?",
                                  ),
                                  action: SnackBarAction(
                                    label: "REMOVER",
                                    textColor: Colors.white,
                                    onPressed: () {
                                      service.removeExercise(
                                          idExercise: exerciseModel.id);
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          exerciseModel.comoFazer,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
