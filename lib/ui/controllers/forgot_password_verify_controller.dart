
import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class ForgotPasswordVerifyController extends GetxController{
  bool _passwordVerifyInProgress = false;
  bool get passwordVerifyInProgress => _passwordVerifyInProgress;
  String?_errorMessage;
  String? get errorMessage => _errorMessage;


  Future <bool> passwordVerifyEmail({required String email}) async {
    bool isSuccess = false;
    _passwordVerifyInProgress = true;
    update();


    NetworkResponse response = await NetworkClient.getRequest(url:
    Urls.forgetPasswordEmailVerifyUrl(email));

    if(response.isSuccess){
      return isSuccess;
    }else{
      _passwordVerifyInProgress = false;
      update();
      _errorMessage = response.errorMessage;
    }
    return isSuccess;
  }
}