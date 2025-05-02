import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/ui/controllers/completed_task_controller.dart';
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
  final CompletedTaskController _completedTaskController = Get.find<CompletedTaskController>();

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
            child: GetBuilder<CompletedTaskController>(
              builder: (controller) {
                return Visibility(
                  visible:controller.getCompletedTaskInProgress == false,
                  replacement: CenteredProgressCircularIndicator(),
                  child: ListView.separated(
                    itemCount:controller.completedTaskList.length,
                    itemBuilder: (context,index){
                      return TaskCard(taskStatus: TaskStatus.completed,
                        taskModel:controller.completedTaskList[index],
                        refreshList: _getAllCompletedTaskList,);
                    },
                    separatorBuilder: (context,index)=>
                    const SizedBox(height: 8,), ),
                );
              }
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getAllCompletedTaskList()async {
    final bool isSuccess = await _completedTaskController
        .getAllCompletedTaskList();

    if (!isSuccess) {
   showSnackBarMessage(context, _completedTaskController.errorMessage!,true);

    }
  }

}



