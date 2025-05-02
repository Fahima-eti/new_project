
import 'package:get/get.dart';
import 'package:new_project/data/models/task-model.dart';

import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';


class CancelledTaskController extends GetxController {
  bool _getCancelledTaskInProgress = false;
  bool get getCancelledTaskInProgress => _getCancelledTaskInProgress;
  String?_errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskModel>_cancelledTaskList = [];
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;

  Future<bool> getAllCancelledTaskList() async {
    bool isSuccess = false;

    _getCancelledTaskInProgress = true;
    update();

    String url = Urls.cancelledTaskListUrl;
    final NetworkResponse response =
    await NetworkClient.getRequest(url:url);
    _getCancelledTaskInProgress = false;
    update();
    if(response.isSuccess){

      TaskListModel taskListModel =
      TaskListModel.fromJson(response.data ?? {});
      _cancelledTaskList = taskListModel.taskList;
      isSuccess = true;
      _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _getCancelledTaskInProgress = false;
    update();

    return isSuccess;
  }
}