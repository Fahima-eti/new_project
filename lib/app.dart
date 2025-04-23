import 'package:flutter/material.dart';
import 'package:new_project/ui/screens/splash_screen.dart';


class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState>
  navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      home: SplashScreen(),
      theme: ThemeData(
          colorSchemeSeed: Colors.green,
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16
            ),
            border: _getZeroBorder(),
            enabledBorder: _getZeroBorder(),

          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                fixedSize:const Size.fromWidth(double.maxFinite),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
                fontSize: 24,fontWeight: FontWeight.w600
            ),
          )
      ),


    );
  }

  OutlineInputBorder _getZeroBorder(){
    return const OutlineInputBorder(
        borderSide: BorderSide.none
    );
  }
}