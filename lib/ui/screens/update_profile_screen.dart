import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_project/Widget/tm_app_bar.dart';
import 'package:new_project/data/models/user_model.dart';
import 'package:new_project/ui/controllers/auth_controller.dart';
import 'package:new_project/ui/controllers/update_profile_controller.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

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

 final UpdateProfileController _updateProfileController = Get.find<UpdateProfileController>();

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
              GetBuilder<UpdateProfileController>(
                builder: (controller) {
                  return Visibility(
                    visible:controller.updateProfileInProgress == false,
                    replacement: CenteredProgressCircularIndicator(),
                    child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: Icon(Icons.arrow_circle_right_outlined, size: 20,)),
                  );
                }
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
    String ? encodedImage;

    final bool isSuccess = await _updateProfileController.updateProfile(
        _EController.text.trim(),
        _FController.text.trim(),
        _LController.text.trim(),
        _MController.text.trim(),
      password: _PController.text.trim().isNotEmpty ? _PController.text.trim() : null,
      photo: encodedImage,
    );
    if(_pickedImage != null){
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
    }

    if (isSuccess) {
      _PController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBarMessage(context, "User data updated successfully")
      );
    } else {
      showSnackBarMessage(context,_updateProfileController.errorMessage!,true);
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
    }
  }
}