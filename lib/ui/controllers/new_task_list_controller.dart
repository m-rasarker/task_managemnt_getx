import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/models/task_model.dart';
import 'package:ruhul_ostab_project/data/models/task_status_count_model.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';


class NewTaskListController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  List<TaskModel> _newTaskList = [];

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  List<TaskModel> get newTaskList => _newTaskList;

  List<TaskStatusCountModel> _taskStatusCountList = [];

  List<TaskStatusCountModel> get TaskStatusCountList => _taskStatusCountList;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getNewTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }



      _newTaskList = list;
      _errorMessage = null;
      isSuccess=true;
    } else {
      isSuccess=false;
      _errorMessage = response.errorMessage!;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }




  Future<bool> getTaskStatusCountList() async {
    _inProgress = true;
    bool isSuccess = false;

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getTaskStatusCountUrl,
    );

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = list;
      isSuccess=true;
      _errorMessage = null;
      update();
    } else {
      isSuccess=false;
      _errorMessage = response.errorMessage!;
      update();
    }

    _inProgress = false;
     update();
    return isSuccess;
  }


}