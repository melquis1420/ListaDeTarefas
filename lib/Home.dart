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
  TextEditingController _controllerTarefa = TextEditingController();

  //finds the directory where the file will be saved
  Future <File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    //print("Caminho:" + diretorio.path);
    return File("${diretorio.path}/dados.json");
  }

  //add task in the task list.
  _salvarTarefa() {
    //recover input text.
    String textoDigitado = _controllerTarefa.text;
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;

    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();

    //convert to json
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      //file recover
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  //data recover
  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  Widget criarItemLista(context, index){
    final item = _listaTarefas[index]["titulo"];

    return Dismissible(
        key: Key(item),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){
          _listaTarefas.removeAt(index);
          _salvarArquivo();
        },
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              )
            ],
          ),
        ),
        child:  CheckboxListTile(
          title: Text(_listaTarefas[index]['titulo']),
          value: _listaTarefas[index]['realizada'],
          onChanged: (valorAlterado) {
            setState(() {
              _listaTarefas[index]['realizada'] = valorAlterado;
            });
            _salvarArquivo();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    //_lerArquivo();
    //_salvarArquivo();
    print("itens: " + _listaTarefas.toString());
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
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {
                      
                    },
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
                        _salvarTarefa();
                        Navigator.pop(context);
                      },
                    ),
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
              itemBuilder: criarItemLista
            ),
          )
        ],
      ),
    );
  }
}
