
import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class UpdateProfileController extends GetxController{
  bool _updateProfileInProgress = false;
  bool get updateProfileInProgress => _updateProfileInProgress;
  String?_errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool>updateProfile(
      String email,
      String firstName,
      String lastName,
      String mobile,
      {String? password,
        String ? photo,}
      ) async {
    _updateProfileInProgress = true;
    update();
    Map<String,dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password != null && password.isNotEmpty) {
      requestBody["password"] = password;
    }

    if (photo != null && photo.isNotEmpty) {
      requestBody["photo"] = photo;
    }

    NetworkResponse response = await NetworkClient.postRequest
      (url: Urls.updateProfileUrl, body: requestBody);

    _updateProfileInProgress = false;
   update();

    if (response.isSuccess) {
      return true;
    } else {
      _errorMessage = response.errorMessage;
      return false;

    }
  }



}