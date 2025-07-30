
import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/models/task_model.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';


class CancelledTaskListController extends GetxController
{

  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;
  List<TaskModel> _cancelledTaskList = [];
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    NetworkResponse response = await NetworkCaller
        .getRequest(url: Urls.getCancelledTasksUrl);

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
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