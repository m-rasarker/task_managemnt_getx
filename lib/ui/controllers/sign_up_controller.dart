import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';

class SignUpController extends GetxController {

  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;


  Future<bool> SignUp(String email,String firstname,String lastname, String mobile, String password) async {
    bool isSuccess =false;
    _inProgress = true;


    Map<String, String> requestBody = {
      "email": email,
      "firstName": firstname,
      "lastName": lastname,
      "mobile": mobile,
      "password": password
    };


    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody, isFromLogin: false,
    );

    _inProgress = false;


    if (response.isSuccess) {
      _inProgress = false;
      isSuccess=true;
      // _clearTextFields();
      // showSnackBarMessage(
      //     context, 'Registration has been success. Please login');
    } else {
      _inProgress = false;
      isSuccess=false;
      _errorMessage = response.errorMessage!;
    }
    return isSuccess;
  }
}