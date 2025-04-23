import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_project/data/service/network_client.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';

import '../../Widget/screen_background.dart';
import '../../data/utils/urls.dart';
import '../../widget/snack_bar_message.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController _EController = TextEditingController();
  final TextEditingController _FController = TextEditingController();
  final TextEditingController _LController = TextEditingController();
  final TextEditingController _MController = TextEditingController();
  final TextEditingController _PController = TextEditingController();
  final GlobalKey<FormState>_formkey = GlobalKey<FormState>();
bool _regisTrationInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child:SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child:Form(
                  key:_formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80,),
                      Text("Join With Us",
                          style:Theme.of(context).textTheme.titleLarge
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller:_EController ,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: _FController,
                          decoration: InputDecoration(
                            hintText:"First name",
                          ),
                        validator: (String?value){
                          if(value?.trim().isEmpty?? true){
                            return "enter your first name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: _LController,
                          decoration: InputDecoration(
                            hintText:"Last name",
                          ),
                        validator: (String?value){
                          if(value?.trim().isEmpty?? true){
                            return "enter your last name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          controller: _MController,
                          decoration: InputDecoration(
                            hintText:"Mobile",
                          ),
                        validator: (String?value){
                            String phone = value?.trim() ?? "";
                            RegExp regExp = RegExp(r"^(?:\+?88|0088)?01[15-9]\d{8}$");
                          if(regExp.hasMatch(phone) == false){
                            return "enter your phone";
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
                          visible: _regisTrationInProgress == false,
                          replacement:const CenteredProgressCircularIndicator(),

                        child: ElevatedButton(
                          onPressed: _onTapSubmitButton,
                          child:Icon(Icons.arrow_circle_right_outlined,size: 20,)),),
                      SizedBox(height: 32,),
                      Center(
                        child: RichText(text: TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,color: Colors.black54,
                            ),
                            children: [
                              TextSpan(text: "Already have an account?"),
                              TextSpan(text: "Sign In",style: TextStyle(
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
                ),
              )
          )

      ),
    );
  }

  void _onTapSubmitButton(){
    if(_formkey.currentState!.validate()){
    _registerUser();
    }
  }

  Future<void> _registerUser () async {
    _regisTrationInProgress = true;
    setState(() {});
    Map<String, String> requestBody = {
      "email": _EController.text.trim(),
      "firstName": _FController.text.trim(),
      "lastName": _LController.text.trim(),
      "mobile": _MController.text.trim(),
      "password": _PController.text,
    };

NetworkResponse response = await NetworkClient.postRequest
  (url: Urls.registerUrl,body: requestBody);

    _regisTrationInProgress = false;
    setState(() {});

    if(response.isSuccess){
      _clearTextField();
ScaffoldMessenger.of(context).showSnackBar(
  showSnackBarMessage(context,"User registration successfully")
);
    }else{

ScaffoldMessenger.of(context).showSnackBar(
   showSnackBarMessage(context,response.errorMessage,true),
);
    }
  }
  void _clearTextField(){

    _FController.clear();
    _PController.clear();
    _MController.clear();
    _LController.clear();
    _EController.clear();


  }

  void _onTapSignInButton(){
    Navigator.pop(context);
  }
  @override
  void dispose() {
    _PController.dispose();
    _MController.dispose();
    _LController.dispose();
    _FController.dispose();
    _EController.dispose();
    super.dispose();
  }


}

