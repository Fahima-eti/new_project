import 'package:flutter/material.dart';
import 'package:new_project/data/models/task-model.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../../widget/snack_bar_message.dart';
import '../../widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  bool _getProgressTaskInProgress = false;
  List<TaskModel>_progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Visibility(
              visible: _getProgressTaskInProgress == false,
              replacement: CenteredProgressCircularIndicator(),
              child: ListView.separated(
                itemCount:_progressTaskList.length,
                itemBuilder: (context,index){
                  return TaskCard(taskStatus:
                  TaskStatus.progress, taskModel:_progressTaskList[index],
                    refreshList: _getAllProgressTaskList,
                  );
                },
                separatorBuilder: (context,index)=>
                const SizedBox(height: 8,), ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getAllProgressTaskList()async{
    _getProgressTaskInProgress = true;
    setState(() {});

    String url = Urls.progressTaskListUrl;
    final NetworkResponse response =
    await NetworkClient.getRequest(url:url);
    _getProgressTaskInProgress = false;
    setState(() {});
    if(response.isSuccess){

      TaskListModel taskListModel =
      TaskListModel.fromJson(response.data ?? {});

      _progressTaskList = taskListModel.taskList;
    }else{
      showSnackBarMessage(context,response.errorMessage,true);
    }
    _getProgressTaskInProgress = false;
    setState(() {});
  }

}



