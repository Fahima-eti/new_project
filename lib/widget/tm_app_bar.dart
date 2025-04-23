import 'package:flutter/material.dart';
import 'package:new_project/ui/controllers/auth_controller.dart';
import 'package:new_project/ui/login_screen.dart';
import 'package:new_project/ui/screens/update_profile_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.fromProfileScreen,
  });

final bool ? fromProfileScreen;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.green.shade400,
      title: GestureDetector(
        onTap: (){
          if(fromProfileScreen ?? false){
            return;
          }
          _onTapProfileSection(context);
        },
        child: Row(
          children: [
            CircleAvatar(radius: 18,
            backgroundImage:NetworkImage("https://images.pexels.com/photos/1133957/pexels-photo-1133957.jpeg"),),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AuthController.userModel?.fulname ?? "Unknown",
                  style: textTheme.bodyLarge?.copyWith(
                      color: Colors.white
                  )),
                  Text(AuthController.userModel?.email ?? "Unknown",
                      style: textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  )),
                ],
              ),
            ),
            IconButton(onPressed: ()=>_onTapLogOutButton(context), icon:Icon(Icons.logout))
          ],
        ),
      ),
    );
  }
  
  void _onTapProfileSection(BuildContext context){
Navigator.push(context, MaterialPageRoute(

    builder: (context)=>UpdateProfileScreen()));
  }
  Future<void>_onTapLogOutButton(BuildContext context)async{
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(

        builder: (context)=>LoginScreen(),),
            (Predicate)=>false);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}