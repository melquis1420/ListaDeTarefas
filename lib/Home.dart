import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];

  _salvarArquivo() async {
    //descobre o diretório onde o arquivo será salvo
    final diretorio = await getApplicationDocumentsDirectory();
    print("Caminho:" + diretorio.path);
    var arquivo = File("${diretorio.path}/dados.json");

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "Ir ao mercado";
    tarefa["realizada"] = false;

    _listaTarefas.add(tarefa);

    //convert to json
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  @override
  Widget build(BuildContext context) {
    _salvarArquivo();
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    FlatButton(
                      child: Text("Cancelar"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text("Salvar"),
                      onPressed: () {
                        //salvar
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _listaTarefas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_listaTarefas[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
