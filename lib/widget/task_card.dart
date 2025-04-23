import 'package:flutter/material.dart';
import 'package:new_project/data/service/network_client.dart';
import 'package:new_project/data/utils/urls.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';
import 'package:new_project/widget/snack_bar_message.dart';

import '../data/models/task-model.dart';

enum TaskStatus {
  sNew,
  progress,
  completed,
  cancelled
}

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskStatus,
    required this.taskModel,
    required this.refreshList,
  });

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.title, style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600
            ),),
            Text(widget.taskModel.description),
            Text(widget.taskModel.createdDate),
            Row(
              children: [
                Chip(label: Text(widget.taskModel.status, style: TextStyle(
                    color: Colors.white
                ),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getStatusChipColor(),
                ),
                const Spacer(),
                Visibility(
                  visible: _inProgress == false,
                  replacement: CenteredProgressCircularIndicator(),
                  child: Row(
                    children: [
                      IconButton(onPressed: _deleteTask, icon: Icon(Icons.delete)),
                      IconButton(onPressed:_showUpdateStatusDialog, icon: Icon(Icons.edit)),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor() {
late Color color;

    switch (widget.taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;

      case TaskStatus.completed:
        color = Colors.green;

      case TaskStatus.cancelled:
       color = Colors.red;
    }
    return color;
  }

  void _showUpdateStatusDialog(){
    showDialog(context: context, builder:(context) {
  return AlertDialog(
    title: Text("Update status"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            onTap: (){
              _popDialog();
              if(isSelected("New")) return;
              _changeTaskStatus("New");
            },
            title: Text("New"),
        trailing:isSelected("New")? Icon(Icons.done) :null),

        ListTile(
            onTap: (){
              _popDialog();
              if(isSelected("Progress")) return;
              _changeTaskStatus("Progress");
            },
            title: Text("Progress"),
        trailing:isSelected("Progress")? Icon(Icons.done) :null),

        ListTile(
            onTap: (){
              _popDialog();
              if(isSelected("Completed")) return;
              _changeTaskStatus("Completed");
            },
            title: Text("Completed"),
      trailing:isSelected("Completed")? Icon(Icons.done) :null),

        ListTile(
            onTap: (){
              _popDialog();
              if(isSelected("Cancelled")) return;
              _changeTaskStatus("Cancelled");
            },
            title: Text("Cancelled"),
            trailing:isSelected("Cancelled")? Icon(Icons.done) :null),

      ],
    ),
  );
    });
  }
  bool isSelected(String status) => widget.taskModel.status == status;

  Future<void>_changeTaskStatus(String status)async{
    _inProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.updateTaskStatusUrl(widget.taskModel.id, status));
    _inProgress = false;
    if(response.isSuccess){
   widget.refreshList;
    }else{
      setState(() {});
      showSnackBarMessage(context, response.errorMessage,true);
    }


  }

  Future<void>_deleteTask()async{
    _inProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.deleteTaskUrl(widget.taskModel.id));
    _inProgress = false;
    if(response.isSuccess){
      widget.refreshList;
    }else{
      setState(() {});
      showSnackBarMessage(context, response.errorMessage,true);
    }


  }
  void _popDialog(){
    Navigator.pop(context);
  }
}