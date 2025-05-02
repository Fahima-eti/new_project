

import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  bool _resetPassInProgress = false;

  bool get resetPassInProgress => _resetPassInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? receivedEmailAndOtp;

  Future<bool> resetPassword(String email, otp, password) async {
    _resetPassInProgress = true;
    update();

    Map <String, dynamic> requestBody = {
      "email": email,
      "OTP" : otp,
      "password": password,
    };
    NetworkResponse response =
    await NetworkClient.postRequest(url:
    Urls.resetPasswordUrl, body: requestBody);

    if (response.isSuccess) {
      _resetPassInProgress = true;
      update();
      return true;
    }else{
      _errorMessage = response.errorMessage;
      return false;
    }
  }
}