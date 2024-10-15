import 'package:flutter/material.dart';
import 'dart:convert';
import '../api/abstractApi.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Map<String, dynamic>> tasks = [];
  final Api api = Api('depositos'); // Utilizando a API para 'depositos'

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final response = await api.getAll();
    final List<dynamic> taskList = json.decode(response);
    setState(() {
      tasks = taskList.map((task) => {'id': task['id'], 'name': task['name'], 'value': task['value']}).toList();
    });
  }

  Future<void> _addTask(String name, double value) async {
    final response = await api.add({'name': name, 'value': value});
    if (response.statusCode == 201) {
      _fetchTasks();
    }
  }

  Future<void> _editTask(int id, String newName, double newValue) async {
    final response = await api.update(id, {'name': newName, 'value': newValue});
    if (response.statusCode == 200) {
      _fetchTasks();
    }
  }

  Future<void> _removeTask(int id) async {
    final response = await api.delete(id);
    if (response.statusCode == 200) {
      _fetchTasks();
    }
  }

  void _showAddDialog() {
    String newTaskName = '';
    double newTaskValue = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Depósito'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newTaskName = value;
                },
                decoration: InputDecoration(hintText: "Nome de Seu depósito"),
              ),
              TextField(
                onChanged: (value) {
                  newTaskValue = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(hintText: "Valor do depósito"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTaskName.isNotEmpty && newTaskValue > 0) {
                  _addTask(newTaskName, newTaskValue);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int index) {
    String updatedTaskName = tasks[index]['name'];
    double updatedTaskValue = tasks[index]['value'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Depósito'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  updatedTaskName = value;
                },
                controller: TextEditingController(text: updatedTaskName),
                decoration: InputDecoration(hintText: "Atualize o nome"),
              ),
              TextField(
                onChanged: (value) {
                  updatedTaskValue = double.tryParse(value) ?? 0.0;
                },
                controller: TextEditingController(text: updatedTaskValue.toString()),
                decoration: InputDecoration(hintText: "Atualize o valor"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (updatedTaskName.isNotEmpty && updatedTaskValue > 0) {
                  _editTask(tasks[index]['id'], updatedTaskName, updatedTaskValue);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Depósitos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index]['name']),
            subtitle: Text('Valor: ${tasks[index]['value'].toString()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditDialog(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeTask(tasks[index]['id']),
                ),
              ],
            ),
            onTap: () => _showEditDialog(index),
          );
        },
      ),
    );
  }
}
