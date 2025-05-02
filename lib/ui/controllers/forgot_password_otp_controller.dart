
import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class ForgotPasswordController extends GetxController{
  bool _passwordVerifyPinInProgress = false;
  bool get passwordVerifyPinInProgress => _passwordVerifyPinInProgress;
  String?_errorMessage;
  String? get errorMessage => _errorMessage;


  Future <bool> passwordPinVerify({required String receivedEmail, required String pin}) async {
    bool isSuccess = false;
    _passwordVerifyPinInProgress = true;
    update();


    NetworkResponse response = await NetworkClient.getRequest(url:
    Urls.forgetPasswordEmailAndPinVerifyUrl(
        email : receivedEmail, otp : pin));

    if(response.isSuccess){
    return isSuccess;
    }else{
      _passwordVerifyPinInProgress = false;
     update();
      _errorMessage = response.errorMessage;
    }
    return isSuccess;
  }
}