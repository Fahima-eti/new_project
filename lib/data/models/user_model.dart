/*class UserModel{
late final String id;
late final String email;
late final String firstName;
late final String lastName;
late final String mobile;
late final String createdDate;

UserModel.convertJsonToDart(Map<String,dynamic>json){
  id = json ["_id"];
  email = json ["email"];
  firstName = json ["firstName"];
  lastName = json ["lastName"];
  mobile = json ["mobile"];
  createdDate = json ["createdDate"];
 }*/

class UserModel {
  late final String id;
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String mobile;
  late final String createdDate;
  late final String photo;

  UserModel.fromJson(Map<String, dynamic>json){
    id = json ["_id"] ?? "";
    email = json ["email"] ?? "";
    firstName = json ["firstName"] ?? "";
    lastName = json ["lastName"] ?? "";
    mobile = json ["mobile"] ?? "";
    createdDate = json ["createdDate"] ?? "";
    photo = json ["photo"] ?? "";
  }

  Map<String,dynamic> toJson(){
    return{
      "_id":id,
      "email":email,
      "firstName":firstName,
      "lastName":lastName,
      "mobile":mobile,
      "createdDate":createdDate,
    };

}
String get fulname{
    return "$firstName $lastName";
}

}

/*class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String createdDate;

UserModel({required this.id,
  required this.email,
  required this.firstName,
  required this.lastName,
  required this.mobile,
  required this.createdDate});

  factory UserModel.convertJsonToDart(Map<String, dynamic>json){
    return UserModel(id: json["_id"] ?? "",
        email: json ["email"] ?? "",
        firstName: json ["firstName"] ?? "",
        lastName:json ["lastName"] ?? "",
        mobile:json ["mobile"] ?? "" ,
        createdDate:  json ["createdDate"] ?? "");
  }
}*/