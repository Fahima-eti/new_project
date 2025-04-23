import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_project/data/models/login_models.dart';
import 'package:new_project/ui/controllers/auth_controller.dart';
import 'package:new_project/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:new_project/ui/screens/main_bottom_nav_screen.dart';
import 'package:new_project/ui/screens/register_screen.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

import '../../Widget/screen_background.dart';
import '../data/service/network_client.dart';
import '../data/utils/urls.dart';
import '../widget/snack_bar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _EController = TextEditingController();
  TextEditingController _PController = TextEditingController();
  final GlobalKey<FormState>_formkey = GlobalKey<FormState>();
  bool _loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child:Padding(
              padding: EdgeInsets.all(24),
              child:Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80,),
                    Text("Get Started With",
                        style:Theme.of(context).textTheme.titleLarge
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: _EController,
                        decoration: InputDecoration(
                          hintText:"Email",
                        ),
                      validator: (String?value){
                        String email = value?.trim() ?? "";

                        if(EmailValidator.validate(email)==false){
                          return "enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      controller: _PController,
                      decoration: InputDecoration(
                          hintText: "Password"
                      ),
                      validator: (String?value){
                        if((value?.trim().isEmpty?? true) || (value!.length<6)){
                          return "enter your password more than 6 letters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16,),
                    Visibility(
                      visible: _loginInProgress == false,
                      replacement:const CenteredProgressCircularIndicator(),
                      child: ElevatedButton(
                          onPressed: _onTapSignInButton,
                          child:Icon(Icons.arrow_circle_right_outlined,size: 20,)),
                    ),
                    SizedBox(height: 32,),
                    Center(
                      child: Column(
                        children: [
                          TextButton(onPressed: _onTapForgotPasswordButton, child:Text("Forgot password?"),),
                          RichText(text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,color: Colors.black54,
                              ),
                              children: [
                                TextSpan(text: "Don't have account?"),
                                TextSpan(text: "Sign Up",style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold
                                ),
                                    recognizer: TapGestureRecognizer()..onTap = _onTapSignUpButton
                                )
                              ]
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              )
          )
      ),
    );
  }
  _onTapSignInButton(){
if(_formkey.currentState!.validate()){
  _login();
}
  }

  Future<void> _login () async {
    _loginInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _EController.text.trim(),
      "password": _PController.text,
    };

    NetworkResponse response = await NetworkClient.postRequest
      (url: Urls.loginUrl,body: requestBody);

    _loginInProgress = false;
    setState(() {});

    if(response.isSuccess){
LoginModel loginModel = LoginModel.fromJson(response.data!);
AuthController.saveUserInformation(loginModel.token, loginModel.userModel);

          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder:
                  (context)=>MainBottomNavScreen()),
                  (predicate)=>false
      );
    }else{

      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBarMessage(context,response.errorMessage,true),
      );
    }
  }

  void _onTapSignUpButton(){
    Navigator.push(context,
        MaterialPageRoute(builder:
            (context)=>RegisterScreen()));
  }

  void _onTapForgotPasswordButton(){
    Navigator.push(context,
        MaterialPageRoute(builder:
            (context)=>ForgotPasswordVerifyEmailScreen()));
  }
  @override
  void dispose() {
    _EController.dispose();
    _PController.dispose();
    super.dispose();
  }

}