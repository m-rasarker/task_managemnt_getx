import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/models/user_model.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';
import 'package:ruhul_ostab_project/ui/controllers/auth_controller.dart';

class  UpdateProfileController extends GetxController{

  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;




  Future<bool> UpdateProfile(String email,String firstname,String lastname, String mobile, String? password, String? photo) async {
    bool isSuccess =false;
    _inProgress = true;
    update();


    Map<String, String> requestBody = {
      "email": email,
      "firstName": firstname,
      "lastName": lastname,
      "mobile": mobile,
    };

    if (password!=null) {
      requestBody['password'] = password;
    }


    if (photo != null) {

      requestBody['photo'] = photo;
    }

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );

    _inProgress = false;


    if (response.isSuccess) {
      UserModel userModel = UserModel(
          id: AuthController.userModel!.id,
          email: email,
          firstName: firstname,
          lastName: lastname,
          mobile: mobile,
          photo: photo
      );

      await AuthController.updateUserData(userModel);
      isSuccess=true;
      _inProgress=false;

      // if (mounted) {
      //   showSnackBarMessage(context, 'Profile updated');
      // }
    } else {
      isSuccess=false;
      _inProgress=false;
      // if (mounted) {
      //   showSnackBarMessage(context, response.errorMessage!);
      // }
    }

    return isSuccess;
  }


}


