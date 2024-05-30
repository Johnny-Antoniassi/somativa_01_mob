import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/cadastrar.dart';

class Login extends StatefulWidget {
  Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  List usuarios = <Users>[];
  bool enc = false;

  final String url = 'http://10.109.83.5:3000/usuarios';

  Future<void> _verificarlogin() async {
    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          print(usuarios);
          usuarios = json.decode(response.body) as List;
        });

        for (int i = 0; i < usuarios.length; i++) {
          if (user.text == usuarios[i]['nome'] &&
              senha.text == usuarios[i]['password']) {
            enc = true;
            break;
          }
        }
        if (enc == true) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MovieScreen()));
          enc = false;
        } else {
          print("Usuário ou senha incorretos.");
        }
      } else {
        print("Erro ao carregar usuários: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao verificar login: $e");
    }
  }

  void _navigateToCadastro() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaCadastro()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[600],
        title: const Text("MangeFix"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    style: TextStyle(color: Colors.blue),
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 50),
                      ),
                      icon: Icon(
                        Icons.person_sharp,
                        color: Colors.blue,
                      ),
                      labelText: "User",
                      labelStyle: TextStyle(color: Colors.blue),
                    ),
                    controller: user,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.blue),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 50),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.blue),
                      icon: Icon(
                        Icons.key,
                        color: Colors.blue,
                      ),
                    ),
                    controller: senha,
                    obscureText: true,
                    obscuringCharacter: "*",
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _verificarlogin();
              },
              child:
                  const Text("Log into", style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToCadastro,
              child:
                  const Text("Register", style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}

class Users {
  String id;
  String login;
  String senha;
  Users(this.id, this.login, this.senha);
  // Função para mapear nossos dados após a leitura da api e
  // retorna id, login  e senha
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(json["id"], json["nome"], json["password"]);
  }
}
