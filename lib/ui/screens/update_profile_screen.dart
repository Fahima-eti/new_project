import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_project/Widget/tm_app_bar.dart';
import 'package:new_project/data/models/user_model.dart';
import 'package:new_project/ui/controllers/auth_controller.dart';
import 'package:new_project/ui/login_screen.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../../widget/snack_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final TextEditingController _EController = TextEditingController();
  final TextEditingController _FController = TextEditingController();
  final TextEditingController _LController = TextEditingController();
  final TextEditingController _MController = TextEditingController();
  final TextEditingController _PController = TextEditingController();
  final GlobalKey<FormState>_formkey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();
  XFile ? _pickedImage;

  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    UserModel userModel = AuthController.userModel!;

    _EController.text = userModel.email;
    _FController.text = userModel.firstName;
    _LController.text = userModel.lastName;
    _MController.text = userModel.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromProfileScreen: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text("Update Profile",
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
              ),
              SizedBox(height: 24,),
              buildPhotoExtractWidget(),
              SizedBox(height: 8,),
              TextFormField(
                controller: _EController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: false,
                decoration: InputDecoration(
                    hintText: "Email"
                ),
                validator: (String?value) {
                  String email = value?.trim() ?? "";

                  if (EmailValidator.validate(email) == false) {
                    return "enter a valid email";
                  }
                  return null;
                },
              ),

              SizedBox(height: 8,),
              TextFormField(
                controller: _FController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: "First name"
                ),
                validator: (String?value) {
                  if (value
                      ?.trim()
                      .isEmpty ?? true) {
                    return "enter your first name";
                  }
                  return null;
                },
              ),

              SizedBox(height: 8,),
              TextFormField(
                controller: _LController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: "Last name"
                ),
                validator: (String?value) {
                  if (value
                      ?.trim()
                      .isEmpty ?? true) {
                    return "enter your last name";
                  }
                  return null;
                },
              ),

              SizedBox(height: 8,),
              TextFormField(
                controller: _MController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: "Phone"
                ),
                validator: (String?value) {
                  String phone = value?.trim() ?? "";
                  RegExp regExp = RegExp(r"^(?:\+?88|0088)?01[15-9]\d{8}$");
                  if (regExp.hasMatch(phone) == false) {
                    return "enter your phone";
                  }
                  return null;
                },
              ),

              SizedBox(height: 8,),
              TextFormField(
                obscureText: true,
                controller: _PController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: "Password"
                ),
              ),
              SizedBox(height: 16,),
              Visibility(
                visible: _updateProfileInProgress == false,
                replacement: CenteredProgressCircularIndicator(),
                child: ElevatedButton(
                    onPressed: _onTapSubmitButton,
                    child: Icon(Icons.arrow_circle_right_outlined, size: 20,)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formkey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, String> requestBody = {
      "email": _EController.text.trim(),
      "firstName": _FController.text.trim(),
      "lastName": _LController.text.trim(),
      "mobile": _MController.text.trim(),
    };
    if (_PController.text.isNotEmpty) {
      requestBody ["password"] = _PController.text;
    }
    if(_pickedImage != null){
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
      requestBody ["photo"] = encodedImage;
    }

    NetworkResponse response = await NetworkClient.postRequest
      (url: Urls.updateProfileUrl, body: requestBody);

    _updateProfileInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      _PController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBarMessage(context, "User data updated successfully")
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBarMessage(context, response.errorMessage, true),
      );
    }
  }

  GestureDetector buildPhotoExtractWidget() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )
              ),
              alignment: Alignment.center,
              child: Text("Photo", style: TextStyle(color: Colors.white),),
            ),
            SizedBox(width: 8,),
            Text(_pickedImage?.name ?? "Select your photo")
          ],
        ),
      ),
    );
  }

  Future<void> _onTapPhotoPicker() async {
    XFile ? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }
}