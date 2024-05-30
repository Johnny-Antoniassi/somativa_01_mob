import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Filme {
  final String nome;
  final String imagem;
  final String duracao;
  final String anoLancamento;
  final String nota;

  Filme(
      {required this.nome,
      required this.imagem,
      required this.duracao,
      required this.anoLancamento,
      required this.nota});

  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      nome: json['nome'],
      imagem: json['imagem'],
      duracao: json['duração'],
      anoLancamento: json['ano de lançamento'],
      nota: json['nota'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 36, 46, 129)),
    home: Login(),
  ));
}

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late String url =
      "https://raw.githubusercontent.com/danielvieira95/DESM-2/master/filmes.json";
  List<Filme> filmes = [];

  @override
  void initState() {
    super.initState();
    _getDados();
  }

  _getDados() async {
    try {
      http.Response resposta = await http.get(Uri.parse(url));
      if (resposta.statusCode == 200) {
        var dados = jsonDecode(resposta.body) as List;
        setState(() {
          filmes = dados.map((json) => Filme.fromJson(json)).toList();
        });
      } else {
        throw Exception('Erro ao obter os dados da API');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visualizar Filmes"),
      ),
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Text(
              " Filmes ",
              style: TextStyle(fontSize: 18),
            ),
            Column(
              children: filmes.map((filme) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          filme.imagem,
                          width: double.infinity,
                          height: 245,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Text(
                          filme.nome,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Duração: ${filme.duracao}",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          "Ano de Lançamento: ${filme.anoLancamento}",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          "Nota: ${filme.nota}",
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
