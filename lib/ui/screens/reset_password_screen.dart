import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/centered_progress_circular_indicator.dart';
import '../../widget/screen_background.dart';
import '../../widget/snack_bar_message.dart';
import '../controllers/reset_password_controller.dart';
import '../login_screen.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _PAController = TextEditingController();
  final TextEditingController _CPController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

 final  ResetPasswordController _resetPasswordController = Get.find<ResetPasswordController>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text("Set Password", style: Theme.of(context).textTheme.titleLarge),
                Text(
                  "Set a new password minimum length of 6 letters.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  obscureText: _obscureText,
                  controller: _PAController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter your password';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: _obscureText,
                  controller: _CPController,
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value != _PAController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GetBuilder<ResetPasswordController>(
                  builder: (controller) {
                    return ElevatedButton(
                      onPressed: controller.resetPassInProgress ? null : _onTapSubmitButton,
                      child: controller.resetPassInProgress
                          ? const CenteredProgressCircularIndicator()
                          : const Text("Confirm"),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54),
                      children: [
                        const TextSpan(text: "Don't have account? "),
                        TextSpan(
                          text: "Sign In",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Get.offAll(LoginScreen(),predicate: (_) => false);
  }

  void _onTapSubmitButton() async {
    if (_formKey.currentState!.validate()) {
      final success = await _resetPasswordController.resetPassword(
        _resetPasswordController.receivedEmailAndOtp!['email'],
        _resetPasswordController.receivedEmailAndOtp!['OTP'],
        _PAController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            showSnackBarMessage(context,"Password Changed successfully")
        );
        Get.offAll(LoginScreen(),predicate: (_) => false
        );
      } else {
        showSnackBarMessage(context,_resetPasswordController.errorMessage!,true);

      }
    }
  }

  @override
  void dispose() {
    _PAController.dispose();
    _CPController.dispose();
    super.dispose();
  }
}
