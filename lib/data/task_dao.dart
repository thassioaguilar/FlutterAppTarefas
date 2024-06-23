import 'package:sqflite/sqflite.dart';
import '/data/database.dart';
import '/components/tasks.dart';

class TaskDao {
  static const String _tablename = 'taskTable';
  static const String _uuid = 'uuid';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';
  static const String _level = 'level';

  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_uuid TEXT, '
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT, '
      '$_level INTEGER)';

  save(Task tarefa) async {
    final Database bancoDeDados = await getDatabase();
    var intemExists = await find(tarefa.uuid);
    Map<String, dynamic> taskMap = toMap(tarefa);
    if (intemExists.isEmpty) {
      return await bancoDeDados.insert(_tablename, taskMap);
    } else {
      return await bancoDeDados.update(
        _tablename,
        taskMap,
        where: '$_uuid = ?',
        whereArgs: [tarefa.uuid],
      );
    }
  }

  updateLevel(Task tarefa) async {
    final Database bancoDeDados = await getDatabase();
    Map<String, dynamic> taskMap = toMap(tarefa);
    return await bancoDeDados.update(
      _tablename,
      taskMap,
      where: '$_uuid = ?',
      whereArgs: [tarefa.uuid],
    );
  }

  Map<String, dynamic> toMap(Task tarefa) {
    final Map<String, dynamic> mapaDeTarefas = {};
    mapaDeTarefas[_uuid] = tarefa.uuid;
    mapaDeTarefas[_name] = tarefa.name;
    mapaDeTarefas[_difficulty] = tarefa.difficulty;
    mapaDeTarefas[_image] = tarefa.image;
    mapaDeTarefas[_level] = tarefa.level;
    return mapaDeTarefas;
  }

  Future<List<Task>> findAll() async {
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> tasks =
        await bancoDeDados.query(_tablename);
    return toList(tasks);
  }

  List<Task> toList(List<Map<String, dynamic>> mapaDeTarefas) {
    List<Task> tarefas = [];

    for (Map<String, dynamic> linha in mapaDeTarefas) {
      var uuid = linha[_uuid];
      var name = linha[_name];
      var image = linha[_image];
      var difficulty = linha[_difficulty];
      var level = linha[_level];
      final Task tarefa = Task(uuid, name, image, difficulty, level);
      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Future<List<Task>> find(String uuid) async {
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> tasks = await bancoDeDados.query(
      _tablename,
      where: '$_uuid = ?',
      whereArgs: [uuid],
    );
    return toList(tasks);
  }

  delete(String uuidDaTarefa) async {
    final Database bancoDeDados = await getDatabase();
    return bancoDeDados.delete(
      _tablename,
      where: '$_uuid = ?',
      whereArgs: [uuidDaTarefa],
    );
  }
}
