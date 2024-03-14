import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gymapp/componets/show_add_edit_exercise_modal.dart';
import 'package:flutter_gymapp/componets/home_widget_list.dart';
import 'package:flutter_gymapp/models/exercise_model.dart';
import 'package:flutter_gymapp/services/service_authentication.dart';
import 'package:flutter_gymapp/services/service_exercise.dart';

class ScreenHome extends StatefulWidget {
  final User user;
  const ScreenHome({super.key, required this.user});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final ServiceExercise service = ServiceExercise();
  bool isDecrescente = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: const Text('Meus Exercícios'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isDecrescente = !isDecrescente;
                });
              },
              icon: const Icon(Icons.sort_by_alpha_rounded),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("assets/logo.png"),
                ),
                accountName: Text((widget.user.displayName != null)
                    ? widget.user.displayName!
                    : ""),
                accountEmail: Text(widget.user.email!),
              ),
              ListTile(
                title: const Text("Quersaber como este app foi feito?"),
                leading: const Icon(Icons.menu_book_rounded),
                dense: true,
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Deslogar'),
                dense: true,
                onTap: () {
                  ServiceAuthentication().deslogarUsuario();
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showAddEditExerciseModal(context);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: StreamBuilder(
            stream: service.connectExerciseStream(isDecrescente),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.docs.isNotEmpty) {
                  List<ExerciseModel> listExercises =
                      []; // Corrigido para ExerciseModel

                  for (var doc in snapshot.data!.docs) {
                    listExercises.add(ExerciseModel.fromMap(
                        doc.data())); // Corrigido para ExerciseModel
                  }
                  return ListView(
                    children: List.generate(
                      listExercises.length,
                      (index) {
                        ExerciseModel exerciseModel = listExercises[index];
                        return startItemList(
                            exerciseModel: exerciseModel, service: service);
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Ainda nenhum exercício!\nVamos adicionar? "),
                  );
                }
              }
            },
          ),
        ));
  }
}
