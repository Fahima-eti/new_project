

import 'package:get/get.dart';
import 'package:new_project/data/models/task-model.dart';

import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';


class CompletedTaskController extends GetxController {
  bool _getCompletedTaskInProgress = false;
  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;
  String?_errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskModel>_completedTaskList = [];
  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<bool> getAllCompletedTaskList() async {
    bool isSuccess = false;

    _getCompletedTaskInProgress = true;
    update();

    String url = Urls.completedTaskListUrl;
    final NetworkResponse response =
    await NetworkClient.getRequest(url:url);
    _getCompletedTaskInProgress = false;
    update();
    if(response.isSuccess){

      TaskListModel taskListModel =
      TaskListModel.fromJson(response.data ?? {});
      _completedTaskList = taskListModel.taskList;
      isSuccess = true;
      _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _getCompletedTaskInProgress = false;
    update();

    return isSuccess;
  }
}