

import 'package:get/get.dart';
import 'package:new_project/data/models/task-model.dart';

import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';


class ProgressTaskController extends GetxController {
  bool _getProgressTaskInProgress = false;
  bool get getProgressTaskInProgress => _getProgressTaskInProgress;
  String?_errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskModel>_progressTaskList = [];
  List<TaskModel> get progressTaskList => _progressTaskList;

  Future<bool> getAllProgressTaskList() async {
    bool isSuccess = false;

    _getProgressTaskInProgress = true;
    update();

    String url = Urls.progressTaskListUrl;
    final NetworkResponse response =
    await NetworkClient.getRequest(url:url);
    _getProgressTaskInProgress = false;
    update();
    if(response.isSuccess){

      TaskListModel taskListModel =
      TaskListModel.fromJson(response.data ?? {});
      _progressTaskList = taskListModel.taskList;
      isSuccess = true;
      _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _getProgressTaskInProgress = false;
    update();

    return isSuccess;
  }
}
