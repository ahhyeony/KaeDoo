import 'package:flutter/material.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';

class TimeRecordWidget extends StatefulWidget {
  final TimeStorage timeStorage;

  TimeRecordWidget({Key? key, required this.timeStorage}) : super(key: key);

  @override
  _TimeRecordWidgetState createState() => _TimeRecordWidgetState();
}

class _TimeRecordWidgetState extends State<TimeRecordWidget> {
  void _editRecord(BuildContext context, int index) {
    final _nameController = TextEditingController(text: widget.timeStorage.getTimeLogs()[index].name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Session Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Enter new session name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.timeStorage.updateRecord(index, _nameController.text.trim().isEmpty ? "Unnamed Session" : _nameController.text.trim());
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRecord(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Record'),
          content: Text('삭제하면 복구할 수 없습니다'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.timeStorage.deleteRecord(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeLogs = widget.timeStorage.getTimeLogs();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '공부시간기록',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: timeLogs.isEmpty
              ? Center(
          )
              : ListView.builder(
            shrinkWrap: true,
            itemCount: timeLogs.length,
            itemBuilder: (context, index) {
              final record = timeLogs[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: ListTile(
                  title: Text(record.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${record.time} on ${record.date}', style: TextStyle(color: Color(0xFF3A6351))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF3A6351)),
                        onPressed: () => _editRecord(context, index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Color(0xFF3A6351)),
                        onPressed: () => _deleteRecord(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}