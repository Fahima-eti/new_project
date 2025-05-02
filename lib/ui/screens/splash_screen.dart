import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_project/ui/controllers/auth_controller.dart';
import 'package:new_project/ui/screens/main_bottom_nav_screen.dart';



import '../../Utlis/asset_path.dart';
import '../../widget/screen_background.dart';
import '../login_screen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextPage();
  }

  Future<void> _moveToNextPage()async{
    await Future.delayed(Duration(seconds: 2));

    final bool _isLoggedIn = await AuthController.checkIfUserLoggedIn();
   Get.off( _isLoggedIn ? const MainBottomNavScreen():
   const LoginScreen());

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:ScreenBackground(
            child: Center(
              child: SvgPicture.asset(AssetPath.logoSvg,
                width: 120,
              ),
            )
        )

    );
  }
}