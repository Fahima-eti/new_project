import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:new_project/ui/controllers/progress_task_controller.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

import '../../widget/snack_bar_message.dart';
import '../../widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  final ProgressTaskController _progressTaskController = Get.find<ProgressTaskController>();

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
            child: GetBuilder<ProgressTaskController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.getProgressTaskInProgress == false,
                  replacement: CenteredProgressCircularIndicator(),
                  child: ListView.separated(
                    itemCount:controller.progressTaskList.length,
                    itemBuilder: (context,index){
                      return TaskCard(taskStatus:
                      TaskStatus.progress, taskModel:controller.progressTaskList[index],
                        refreshList: _getAllProgressTaskList,
                      );
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

  Future<void> _getAllProgressTaskList()async{
    final bool isSuccess = await _progressTaskController.getAllProgressTaskList();

    if(!isSuccess) {
      showSnackBarMessage(context,_progressTaskController.errorMessage!, true);
    }
  }

}



