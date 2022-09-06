import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _toDoList = [];

  @override
  void initState() {
    super.initState();
    // _readData().then((data) {
    // setState(() {
    //_toDoList = json.decode(data!);
    //    });
//   });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo['title'] = _toDoController.text;
      _toDoController.text = '';
      newToDo['ok'] = false;
      _toDoList.add(newToDo);
      // _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: buildTextField(
                    'Nova Tarefa',
                    _toDoController,
                  ),
                ),
                ElevatedButton(
                  onPressed: _addToDo,
                  child: const Text(
                    'ADD',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: buildItem),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return CheckboxListTile(
      title: Text(_toDoList[index]['title']),
      value: _toDoList[index]['ok'],
      secondary: CircleAvatar(
        child: Icon(
          _toDoList[index]['ok'] ? Icons.check : Icons.error,
        ),
      ),
      onChanged: (check) {
        setState(() {
          _toDoList[index]['ok'] = check;
          //    _saveData();
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  // Future<String?> _readData() async {
  // try {
  //  final file = await _getFile();
  //  return file.readAsString();
  // } catch (e) {
  // return null;
  //  }
  //}
}

Widget buildTextField(
  String labelText,
  TextEditingController controller,
) {
  return TextField(
    minLines: 1,
    maxLines: 15,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.blue,
      ),
    ),
  );
}
