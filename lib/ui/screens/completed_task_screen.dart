import 'package:flutter/material.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

import '../../data/models/task-model.dart';
import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../../widget/snack_bar_message.dart';
import '../../widget/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskInProgress = false;
  List<TaskModel>_completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllCompletedTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Visibility(
              visible: _getCompletedTaskInProgress == false,
              replacement: CenteredProgressCircularIndicator(),
              child: ListView.separated(
                itemCount:_completedTaskList.length,
                itemBuilder: (context,index){
                  return TaskCard(taskStatus: TaskStatus.completed,
                    taskModel: _completedTaskList[index],
                    refreshList: _getAllCompletedTaskList,);
                },
                separatorBuilder: (context,index)=>
                const SizedBox(height: 8,), ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getAllCompletedTaskList()async{
    _getCompletedTaskInProgress = true;
    setState(() {});

    String url = Urls.completedTaskListUrl;
    final NetworkResponse response =
    await NetworkClient.getRequest(url:url);
    _getCompletedTaskInProgress = false;
    setState(() {});
    if(response.isSuccess){

      TaskListModel taskListModel =
      TaskListModel.fromJson(response.data ?? {});

      _completedTaskList = taskListModel.taskList;
    }else{
      showSnackBarMessage(context,response.errorMessage,true);
    }
    _getCompletedTaskInProgress = false;
    setState(() {});
  }

}



