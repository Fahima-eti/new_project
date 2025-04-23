import 'package:new_project/data/models/user_model.dart';

class LoginModel{
  late final String status;
  late final String token;
  late final UserModel userModel;

  LoginModel.fromJson(Map<String,dynamic>json){
    status = json ["status"] ?? "";
    userModel = UserModel.fromJson(json["data"] ?? {});
    token = json ["token"] ?? "";
  }

}