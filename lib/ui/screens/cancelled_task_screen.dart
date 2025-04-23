import 'package:flutter/material.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

import '../../data/models/task-model.dart';
import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../../widget/snack_bar_message.dart';
import '../../widget/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskInProgress = false;
  List<TaskModel>_cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllCancelledTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Visibility(
              visible: _getCancelledTaskInProgress == false,
              replacement: CenteredProgressCircularIndicator(),
              child: ListView.separated(
                itemCount:_cancelledTaskList.length,
                itemBuilder: (context,index){
                 return TaskCard(taskStatus: TaskStatus.cancelled,
                   taskModel: _cancelledTaskList[index],
                   refreshList: _getAllCancelledTaskList);
                },
                separatorBuilder: (context,index)=>
                const SizedBox(height: 8,), ),
            ),
          )
        ],
      ),
    );
  }
  Future<void> _getAllCancelledTaskList()async{
    _getCancelledTaskInProgress = true;
    setState(() {});

    String url = Urls.cancelledTaskListUrl;
    final NetworkResponse response =
    await NetworkClient.getRequest(url:url);
    _getCancelledTaskInProgress = false;
    setState(() {});
    if(response.isSuccess){

      TaskListModel taskListModel =
      TaskListModel.fromJson(response.data ?? {});

      _cancelledTaskList = taskListModel.taskList;
    }else{
      showSnackBarMessage(context,response.errorMessage,true);
    }
    _getCancelledTaskInProgress = false;
    setState(() {});
  }


}





