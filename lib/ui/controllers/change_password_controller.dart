import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';
import 'package:ruhul_ostab_project/ui/widgets/snack_bar_message.dart';

class ChangePasswordController extends GetxController{
  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> ChangePassword(String email,String otp,String password) async {
    bool isSuccess =false;
   _inProgress= true;

    // Map<String, String> requestBody = {
    //   "email": ChangePasswordScreen.email.toString(),
    //   "OTP": ChangePasswordScreen.otpCode.toString(),
    //   "password":_confirmPasswordTEController.text.toString()
    // };


    Map<String, String> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password
    };


    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.RecoverResetPasswordUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      _inProgress = false;
      isSuccess=true;
      update();

     // showSnackBarMessage(context, "Password Changed Successfully");
    //  Navigator.pushReplacementNamed(context, SignInScreen.name);
    } else {
      _inProgress = false;
      isSuccess=false;
        _errorMessage = response.errorMessage!;
    }

    return isSuccess;
  }






}
