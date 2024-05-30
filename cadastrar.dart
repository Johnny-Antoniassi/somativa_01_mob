import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  final String url = 'http://10.109.83.9:3000/usuarios';

  void cadastrarUsuario() async {
    String nome = nomeController.text;
    String senha = senhaController.text;

    Map<String, String> novoUsuario = {
      'nome': nome,
      'password': senha,
    };

    // Enviar a requisição POST com os dados do novo usuário
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(novoUsuario),
    );

    if (response.statusCode == 200) {
      // Sucesso
      print('Usuário cadastrado com sucesso!');
      Navigator.pop(context); // Volta para a tela anterior
    } else {
      // Erro
      print(
          'Erro ao cadastrar usuário. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome de Usuário',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: cadastrarUsuario,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
