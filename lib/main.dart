import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeworkData.dart';

void main() => runApp( HomeworkApp());

class HomeworkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework',
      home: Homework(),
    );
  }
}

class Homework extends StatefulWidget {
  @override
  _HomeworkState createState() => _HomeworkState();
}

class _HomeworkState extends State<Homework> {
  List<HomeworkData> homeworkList = new List<HomeworkData>();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('Homework List',
          style: TextStyle(
            fontSize: 20,
          ),
          ),
      ),
      body: Column(
        children: <Widget>[
          DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(
              label: const Text('Assignment'),
                tooltip: 'Assignment',
                numeric: false,
                 onSort: (int columnIndex, bool ascending) {
                  //homeworkList.add('column-sort: $columnIndex $ascending');
                },
              ),
              DataColumn(
                label: const Text('Points'),
                tooltip: 'Points',
                numeric: true,
                 onSort: (int columnIndex, bool ascending) {
                  //homeworkList.add('column-sort: $columnIndex $ascending');
                },
              ),
              DataColumn(
                label: Text(''),
                tooltip: 'Delete', 
                
              ),
            ],
            rows: homeworkList.map(
              (homework) => DataRow(
                cells: <DataCell>[
                  DataCell(
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 250,
                        child: TextField(
                          controller: TextEditingController(text: homework.Assignment),
                          onChanged:(text) {
                             homework.Assignment = text;
                            _save();
                          },
                        ),
                      ),
                  ),
                  DataCell(
                    Container(
                      width: 50,
                      child: TextField(
                        controller: TextEditingController(text: homework.Points),
                        onChanged:(text) {
                          setState(() {
                            var value = text;
                            if (value == '')
                              value = '0';
                            homework.Points = value;
                            _save();
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.centerRight,
                      width: 20,
                      child: MaterialButton(
                        child: Icon(Icons.delete),
                        onPressed: () => {
                          setState(() {
                            homeworkList.remove(homework);
                            _save();
                          })
                        },
                        
                      ),
                    )
                  )
                ],
              ),
            ).toList(),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Text('Total Points:$totalPoints'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          this.setState(()=>{
            homeworkList.add(HomeworkData(Assignment: 'new homework', Points: '0'))
          })
        },
      ),
    );
    _read();
    return scaffold;
  }

  String get totalPoints {
    var total = 0;
    homeworkList.forEach((homework) {
      var pts = int.tryParse(homework.Points);
      if (pts != null)
        total += pts;
    });
    return total.toString();
  }

  _read() async {
    setState(() async {
      final prefs = await SharedPreferences.getInstance();
      final key = 'homeworkList';
      final value = prefs.getString(key) ?? '';
      if (value == '') {
        homeworkList = new List<HomeworkData>();
      } else {
        var list = jsonDecode(value);
        list.forEach((x) => homeworkList.add(HomeworkData(Assignment: x["Assignment"], Points: x["Points"])));
      }
      print('read: $value');
    });

  }

_save() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'homeworkList';
  final value = jsonEncode(homeworkList);
  prefs.setString(key, value);
  print('saved $value');
}

}

