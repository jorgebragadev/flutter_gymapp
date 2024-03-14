import 'package:flutter/material.dart';
import 'package:flutter_gymapp/_common/my_colors.dart';
import 'package:flutter_gymapp/componets/field_decoration_authentication.dart';
import 'package:flutter_gymapp/models/exercise_model.dart';
import 'package:flutter_gymapp/models/feeling_model.dart';
import 'package:flutter_gymapp/services/service_exercise.dart';
import 'package:flutter_gymapp/services/service_feeling.dart';
import 'package:uuid/uuid.dart';

showAddEditExerciseModal(BuildContext context, {ExerciseModel? exercise}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: MyColors.DarkBlue,
    isDismissible: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(32), 
      ),
    ),
    builder: (context) {
      return ExerciseModal(
        exerciseModel: exercise,
      );
    },
  );
}

class ExerciseModal extends StatefulWidget {
  final ExerciseModel? exerciseModel;
  const ExerciseModal({super.key, this.exerciseModel});

  @override
  State<ExerciseModal> createState() => _ExerciseModalState();
}

class _ExerciseModalState extends State<ExerciseModal> {
  TextEditingController _nomeCtrl = TextEditingController();
  TextEditingController _treinoCtrl = TextEditingController();
  TextEditingController _anotacoesCtrl = TextEditingController();
  TextEditingController _sentindoCtrl = TextEditingController();

  bool isCarregando = false;

  ServiceExercise _serviceExercise = ServiceExercise();

  @override
  void initState() {
    if (widget.exerciseModel != null) {
      _nomeCtrl.text = widget.exerciseModel!.name;
      _treinoCtrl.text = widget.exerciseModel!.treino;
      _anotacoesCtrl.text = widget.exerciseModel!.comoFazer;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        (widget.exerciseModel != null)
                            ? "Editar ${widget.exerciseModel!.name}"
                            : "Adicionar Exercício",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nomeCtrl,
                      decoration: getAuthenticationInputDecartion(
                        "Qual o nome do exercício?",
                        icon: const Icon(
                          Icons.abc,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _treinoCtrl,
                      decoration: getAuthenticationInputDecartion(
                        "Qual o treino pertence?",
                        icon: const Icon(
                          Icons.list_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      "Use o mesmo nome para exercícios que pertencem ao mesmo treino.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _anotacoesCtrl,
                      decoration: getAuthenticationInputDecartion(
                        "Qual a anotação você tem?",
                        icon: const Icon(
                          Icons.notes_rounded,
                          color: Colors.white,
                        ),
                      ),
                      maxLines: null,
                    ),
                    Visibility(
                        visible: (widget.exerciseModel == null),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            TextField(
                              controller: _sentindoCtrl,
                              decoration: getAuthenticationInputDecartion(
                                "Como você esta se sentindo?",
                                icon: const Icon(
                                  Icons.emoji_emotions_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              maxLines: null,
                            ),
                            const Text(
                              "Você não precisa preencher isso agora.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                sendClick();
              },
              child: (isCarregando)
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: MyColors.DarkBlue,
                      ),
                    )
                  : Text((widget.exerciseModel != null)
                      ? "Editar exercício"
                      : "Criar exercício"),
            ),
          ],
        ),
      ),
    );
  }

  sendClick() {
    setState(() {
      isCarregando = true;
    });
    String nome = _nomeCtrl.text;
    String treino = _treinoCtrl.text;
    String anotacoes = _anotacoesCtrl.text;
    String sentindo = _sentindoCtrl.text;

    ExerciseModel exercise = ExerciseModel(
        id: const Uuid().v1(),
        name: nome,
        treino: treino,
        comoFazer: anotacoes);

    if (widget.exerciseModel != null) {
      exercise.id = widget.exerciseModel!.id;
    }
    _serviceExercise.addExercise(exercise).then((value) {
      if (sentindo != "") {
        FeelingModel feeling = FeelingModel(
          id: const Uuid().v1(),
          sentindo: sentindo,
          data: DateTime.now().toString(),
        );
        ServiceFeelig()
        .addFeeling(idExercise: exercise.id, feelingModel: feeling).then((value) {
          setState(() {
            isCarregando = false;
          });
          Navigator.pop(context);
        });
      } else {
        Navigator.pop(context);
      }
    });
  }
}
