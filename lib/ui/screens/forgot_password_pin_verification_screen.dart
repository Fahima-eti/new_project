
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_project/ui/screens/reset_password_screen.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Widget/screen_background.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../../widget/snack_bar_message.dart';
import '../login_screen.dart';


class ForgotPasswordVerifyPinEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyPinEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyPinEmailScreen> createState() => _ForgotPasswordVerifyPinEmailScreenState();
}

class _ForgotPasswordVerifyPinEmailScreenState extends State<ForgotPasswordVerifyPinEmailScreen> {
  TextEditingController _PinController = TextEditingController();
  final GlobalKey<FormState>_formkey = GlobalKey<FormState>();

  bool _passwordVerifyPinInProgress = false;

  String ? receivedEmail;

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
                    Text("Pin Verification",
                        style:Theme.of(context).textTheme.titleLarge
                    ),
                    Text("A 6 digit verification pin has been sent to your email.",
                        style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey

                        )
                    ),
                    SizedBox(height: 24),
                    PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,

                      controller: _PinController,
                      appContext: context,

                      validator: (String? value) {
                        if (value!.trim().isEmpty == true) {
                          return 'Please Provide your OTP';
                        } else if (value.trim().length < 6) {
                          return 'Provide valid OTP';
                        }
                        return null;
                      },


                    ),
                    SizedBox(height: 16,),

                    SizedBox(height: 16,),
                    ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child:Visibility(
                            visible: _passwordVerifyPinInProgress == false,
                            replacement: CenteredProgressCircularIndicator(),

                            child: Text("Verify"))),
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
                                recognizer: TapGestureRecognizer()..onTap = _onTapSignUpButton
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
      _passwordPinVerify();
    }
  }

  Future<void>_passwordPinVerify() async {
    _passwordVerifyPinInProgress = true;
    setState(() {});

    final String pin = _PinController.text;

    NetworkResponse response = await NetworkClient.getRequest(url:
    Urls.forgetPasswordEmailAndPinVerifyUrl(
        email : receivedEmail, otp : pin));

    if(response.isSuccess){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder:
              (context) => ResetPasswordScreen()),
              (predicate)=>false);
    }else{
      _passwordVerifyPinInProgress = false;
      setState(() {});
      showSnackBarMessage(context,
          "invalid Otp!please enter a valid otp",true);
    }
  }

  void _onTapSignUpButton(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder:
          (context)=> const LoginScreen()),
          (pre)=>false,
    );

  }
  @override
  void dispose() {
    _PinController.dispose();
    super.dispose();
  }



}