import 'package:get/get.dart';
import 'package:ruhul_ostab_project/ui/controllers/add_new_task_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/auth_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/change_password_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/completed_task_list_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/forgot_password_email_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/new_task_list_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/pin_verification_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/progress_task_list_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/sign_in_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/sign_up_controller.dart';
import 'package:ruhul_ostab_project/ui/screens/pages/update_profile_screen.dart';

import 'controllers/cancelled_task_list_controller.dart';


class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(ProgressTaskListController());
    Get.put(CompletedTaskListController());
    Get.put(CancelledTaskListController());
    Get.put(AddNewTaskController());
    Get.put(ForgotPasswordEmailController());
    Get.put(PinVerificationController());
    Get.put(ChangePasswordController());
    Get.put(AuthController());
    Get.put(UpdateProfileScreen());
    Get.put(SignUpController());


  }
}