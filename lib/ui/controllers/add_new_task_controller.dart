
import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';

class AddNewTaskController extends GetxController{

  bool _inProgress = false;
  bool isSuccess = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;



  Future<bool> addNewTask(String title,String description, String status) async {
    _inProgress = true;
    update();

    Map<String, String> requestBody = {
      "title": title,
      "description": description,
      "status": status,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.createNewTaskUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess=true;
      _inProgress=false;
      _errorMessage=null;
      update();

    } else {
      isSuccess=false;
      _inProgress=false;
      _errorMessage = response.errorMessage;

      update();

    }
    _inProgress=false;
    update();
    return isSuccess;

  }


}