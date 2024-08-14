import 'package:hive_flutter/hive_flutter.dart';

class HiveCRUD {
  final _myBox = Hive.box('Events');

  void writeData(List data) {
    int index = _myBox.length; // Use the current length of the box to get the next index
    _myBox.put(index, data);
    print(_myBox.get(index));
  }

  List<List> readData(int key) {
    return _myBox.get(key);
  }

  void deleteData(int key) {
    _myBox.delete(key);
  }
}