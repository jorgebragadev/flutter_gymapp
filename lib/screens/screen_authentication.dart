import 'package:flutter/material.dart';
import 'package:flutter_gymapp/_common/my_colors.dart';
import 'package:flutter_gymapp/_common/my_snackbar.dart';
import 'package:flutter_gymapp/componets/field_decoration_authentication.dart';
import 'package:flutter_gymapp/services/service_authentication.dart';

class ScreenAuthentication extends StatefulWidget {
  const ScreenAuthentication({super.key});

  @override
  State<ScreenAuthentication> createState() => _ScreenAuthenticationState();
}

class _ScreenAuthenticationState extends State<ScreenAuthentication> {
  bool toEnter = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  ServiceAuthentication _serviceAuthentication = ServiceAuthentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MyColors.BlueGradientTop, MyColors.BlueGradientLow],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          height: 128,
                          color: Colors.white,
                        ),
                        const Text(
                          "GymApp",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: getAuthenticationInputDecartion("E-mail"),
                          validator: (String? value) {
                            if (value == null) {
                              return "O e-mail não pode ser vazio";
                            }
                            if (value.length < 5) {
                              return "O e-mail é muito curto";
                            }
                            if (!value.contains("@")) {
                              return "O e-mail é inválido";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller:
                              _senhaController, // Adicione o controlador
                          decoration: getAuthenticationInputDecartion("Senha"),
                          obscureText: true,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "A senha não pode ser vazia";
                            }
                            if (value.length < 5) {
                              return "A senha é muito curta";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Visibility(
                            visible: !toEnter,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller:
                                      _confirmarSenhaController, // Adicione o controlador
                                  decoration: getAuthenticationInputDecartion(
                                      "Confirme Senha"),
                                  obscureText: true,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "A confimação de senha não pode ser vazia";
                                    }
                                    if (value.length < 5) {
                                      return "A confirmaçaso de senha é muito curta";
                                    }
                                    if (value != _senhaController.text) {
                                      return "As senhas não coincidem";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nomeController,
                                  decoration:
                                      getAuthenticationInputDecartion("Nome"),
                                  validator: (String? value) {
                                    if (value == null) {
                                      return "O nome não pode ser vazio";
                                    }
                                    if (value.length < 5) {
                                      return "O nome é muito curto";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              mainButtonClicked();
                            },
                            child: Text((toEnter) ? "Entrar" : "Cadastrar")),
                        const Divider(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              toEnter = !toEnter;
                            });
                          },
                          child: Text((toEnter)
                              ? "Ainda não tem cadastro? Cadastre-se!"
                              : "Já tem conta? Entre!"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  mainButtonClicked() {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;

    if (_formKey.currentState!.validate()) {
      if (toEnter) {
        _serviceAuthentication
            .autenticarUsuario(email: email, senha: senha)
            .then((String? erro) {
          if (erro != null) {
            showSnackbar(context: context, message: erro);
          } else {}
        });
      } else {
  
        print("${_emailController}, ${_senhaController}, ${_nomeController},");
        _serviceAuthentication
            .cadastrarUsuario(nome: nome, email: email, senha: senha)
            .then(
          (String? erro) {
            if (erro != null) {
              //Voltou com erro
              showSnackbar(context: context, message: erro);
            }
          },
        );
      }
    } else {
      print("Form Inválido!");
    }
  }
}
