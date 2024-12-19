import 'package:flutter/foundation.dart';
import 'package:todo/models/task.dart';
import 'package:todo/helpers/database_helper.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  TaskData() {
    _loadTasks();
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  // Load tasks from SQLite database
  Future<void> _loadTasks() async {
    _tasks = await _dbHelper.getTasks();
    notifyListeners();
  }

  // Adds task to SQLite database
  Future<void> addTask(String newTaskTitle) async {
    Task task = Task(name: newTaskTitle);
    await _dbHelper.insertTask(task);
    _loadTasks();
    notifyListeners();
  }

  // Update task in SQLite database
  Future<void> updateTask(Task task) async {
    task.toggleDone();
    await _dbHelper.updateTask(task);
    _loadTasks();
    notifyListeners();
  }

  // Delete task from SQLite database
  Future<void> deleteTask(Task task) async {
    await _dbHelper.deleteTask(task.id!);
    _loadTasks();
    notifyListeners();
  }
}
