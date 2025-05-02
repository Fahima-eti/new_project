

import 'package:get/get.dart';
import 'package:new_project/ui/controllers/add_new_task_controller.dart';
import 'package:new_project/ui/controllers/cancelled_task_controller.dart';
import 'package:new_project/ui/controllers/completed_task_controller.dart';
import 'package:new_project/ui/controllers/forgot_password_otp_controller.dart';
import 'package:new_project/ui/controllers/forgot_password_verify_controller.dart';
import 'package:new_project/ui/controllers/login_controller.dart';
import 'package:new_project/ui/controllers/new_task_controller.dart';
import 'package:new_project/ui/controllers/progress_task_controller.dart';
import 'package:new_project/ui/controllers/register_controller.dart';
import 'package:new_project/ui/controllers/reset_password_controller.dart';
import 'package:new_project/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
  Get.put(LoginController());
  Get.put(NewTaskController());
  Get.put(RegisterController());
  Get.put(UpdateProfileController());
  Get.put(ResetPasswordController());
  Get.put(AddNewTaskController());
  Get.put(ProgressTaskController());
  Get.put(CancelledTaskController());
  Get.put(CompletedTaskController());
  Get.put(ForgotPasswordController());
  Get.put(ForgotPasswordVerifyController());

  }

}