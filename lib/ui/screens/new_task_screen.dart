import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/data/models/task_status_count_list_model.dart';
import 'package:new_project/data/models/task_status_count_model.dart';
import 'package:new_project/data/service/network_client.dart';
import 'package:new_project/data/utils/urls.dart';
import 'package:new_project/ui/controllers/new_task_controller.dart';
import 'package:new_project/ui/screens/add_new_task_screen.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';
import 'package:new_project/widget/snack_bar_message.dart';
import '../../widget/summary_card.dart';
import '../../widget/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];


  @override
  void initState() {
    super.initState();
    getAllTaskStatusCount();
    getAllNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: _getStatusCountInProgress == false,
              replacement: const Padding(
                padding: EdgeInsets.all(16),
                child: CenteredProgressCircularIndicator(),
              ),
              child: _buildSummarySection(),
            ),
            GetBuilder<NewTaskController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.getNewTaskInProgress == false,
                    replacement: const SizedBox(
                      height: 300,
                      child: CenteredProgressCircularIndicator(),
                    ),
                    child: ListView.separated(
                      itemCount: controller.newTaskList.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskStatus: TaskStatus.sNew,
                          taskModel: controller.newTaskList[index],
                          refreshList: getAllNewTaskList,

                        );
                      },
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                    ),
                  );
                }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTask() {
    Get.to(AddNewTaskScreen());
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _taskStatusCountList.length,
          itemBuilder: (context, index) {
            return SummaryCard(
                title: _taskStatusCountList[index].status,
                count: _taskStatusCountList[index].count);
          },
        ),
      ),
    );
  }

  Future<void> getAllNewTaskList() async {
    final bool isSuccess = await Get.find<NewTaskController>().getNewTaskList();

    if (!isSuccess) {
      showSnackBarMessage(context,
          Get.find<NewTaskController>().errorMessage!, true);
    }
  }

  Future<void> getAllTaskStatusCount() async {
    _getStatusCountInProgress = true;
    setState(() {});

    String url = Urls.taskStatusCountUrl;
    final NetworkResponse response =
    await NetworkClient.getRequest(url: url);
    if (response.isSuccess) {
      TaskStatusCountListModel taskStatusCountListModel =
      TaskStatusCountListModel.fromJson(response.data ?? {});

      _taskStatusCountList = taskStatusCountListModel.statusCountList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getStatusCountInProgress = false;
    setState(() {});
  }

}

