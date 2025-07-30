import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';
class ForgotPasswordEmailController extends GetxController{
  bool _inProgress = false;
  bool isSuccess = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;




  Future<bool> Emailverity(String? email) async {
    bool isSuccess = false;
    _inProgress = true;
    update();


    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.RecoverVerifyEmail(email!));

    if (response.isSuccess) {
      _inProgress = false;
      isSuccess=true;
      update();
    } else {
      _inProgress = false;
      isSuccess=false;
      update();
    //  showSnackBarMessage(context, response.errorMessage!);
      _errorMessage = response.errorMessage;

    }
    return isSuccess;
  }



}

