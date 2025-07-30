import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';

class PinVerificationController extends GetxController{
  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;


  Future<bool> Pinverity( String email,String otp) async {
    bool isSuccess = false;
    bool _inProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.RecoverVerifyOtpEmail(email ,otp)
    );



    if (response.isSuccess) {
      _inProgress = false;
      isSuccess =true;
      update();


    } else {
      _inProgress = false;
      isSuccess =false;
      update();
      _errorMessage= response.errorMessage.toString();


    }
     return isSuccess;
  }


}
