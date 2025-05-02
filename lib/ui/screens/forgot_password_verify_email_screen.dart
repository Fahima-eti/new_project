import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/ui/controllers/forgot_password_verify_controller.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';
import 'package:new_project/widget/snack_bar_message.dart';

import '../../Widget/screen_background.dart';

import 'forgot_password_pin_verification_screen.dart';


class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() => _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState extends State<ForgotPasswordVerifyEmailScreen> {
  TextEditingController _EController = TextEditingController();
  final GlobalKey<FormState>_formkey = GlobalKey<FormState>();

  final ForgotPasswordVerifyController _forgotPasswordVerifyController = Get.find<ForgotPasswordVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child:Padding(
              padding: EdgeInsets.all(24),
              child:Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80,),
                    Text("Your Email Address",
                        style:Theme.of(context).textTheme.titleLarge
                    ),
                    Text("A 6 digit verification pin will be sent to your email.",
                        style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey

                        )
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: _EController,
                        decoration: InputDecoration(
                          hintText:"Email",
                        ),
                      validator: (String?value) {
                        String email = value?.trim() ?? "";

                        if (EmailValidator.validate(email) == false) {
                          return "enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16,),

                    SizedBox(height: 16,),
                    GetBuilder<ForgotPasswordVerifyController>(
                      builder: (controller) {
                        return Visibility(
                          visible:controller.passwordVerifyInProgress == false,
                          replacement: CenteredProgressCircularIndicator(),
                          child: ElevatedButton(
                              onPressed: _onTapSubmitButton,
                              child:Icon(Icons.arrow_circle_right_outlined,size: 20,)),
                        );
                      }
                    ),
                    SizedBox(height: 32,),
                    Center(
                      child: RichText(text: TextSpan(
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
                                recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton
                            )
                          ]
                      )),
                    )
                  ],
                ),
              )
          )
      ),
    );
  }
  void _onTapSubmitButton(){
    if (_formkey.currentState!.validate()) {
      _passwordVerifyEmail();
    }
  }
  Future<void>_passwordVerifyEmail() async {
    String email = _EController.text.trim();

    final bool isSuccess = await _forgotPasswordVerifyController.passwordVerifyEmail(email: email);

    if(isSuccess){
      Get.offAll(ForgotPasswordVerifyPinEmailScreen(),predicate: (_) => false);
    }else{
      showSnackBarMessage(
          context,
          _forgotPasswordVerifyController.errorMessage ?? "email is not found",true);
    }


  }

  void _onTapSignInButton(){
    Navigator.pop(context);
  }
  @override
  void dispose() {
    _EController.dispose();
    super.dispose();
  }




}