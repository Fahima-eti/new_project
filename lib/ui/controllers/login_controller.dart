
import 'package:get/get.dart';

import '../../data/models/login_models.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  bool _loginInProgress = false;
  bool get loginInProgress => _loginInProgress;
  String?_errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login (String email,String password) async {
    _loginInProgress = true;
    update();
    bool isSuccess = false;
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password
    };

    NetworkResponse response = await NetworkClient.postRequest
      (url: Urls.loginUrl,body: requestBody);

    if(response.isSuccess){
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      await AuthController.saveUserInformation(loginModel.token, loginModel.userModel);
      isSuccess = true;
    _errorMessage = null;
    }else{
     _errorMessage = response.errorMessage;
    }
    _loginInProgress = true;
    update();

    return isSuccess;
  }
}