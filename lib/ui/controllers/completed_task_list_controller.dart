
import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/models/task_model.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';


class CompletedTaskListController extends GetxController
{

  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;
  List<TaskModel> _completedTaskList = [];
  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    NetworkResponse response = await NetworkCaller
        .getRequest(url: Urls.getCompletedTasksUrl);

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList= list;
      isSuccess=true;
      _errorMessage = null;
    } else {
      isSuccess=false;
      _errorMessage = response.errorMessage!;
    }

    _inProgress = false;
    update();
  return isSuccess;
  }


}