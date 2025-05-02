import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/ui/controllers/cancelled_task_controller.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

import '../../widget/snack_bar_message.dart';
import '../../widget/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final CancelledTaskController _cancelledTaskController = Get.find<CancelledTaskController>();

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
            child: GetBuilder<CancelledTaskController>(
              builder: (controller) {
                return Visibility(
                  visible:controller.getCancelledTaskInProgress == false,
                  replacement: CenteredProgressCircularIndicator(),
                  child: ListView.separated(
                    itemCount:controller.cancelledTaskList.length,
                    itemBuilder: (context,index){
                     return TaskCard(taskStatus: TaskStatus.cancelled,
                       taskModel:controller.cancelledTaskList[index],
                       refreshList: _getAllCancelledTaskList);
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
  Future<void> _getAllCancelledTaskList()async {
    final bool isSuccess = await _cancelledTaskController
        .getAllCancelledTaskList();

    if (!isSuccess) {
      showSnackBarMessage(context,
          _cancelledTaskController.errorMessage!, true);
    }
  }
}





