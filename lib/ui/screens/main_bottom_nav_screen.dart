import 'package:flutter/material.dart';
import 'package:new_project/ui/screens/cancelled_task_screen.dart';
import 'package:new_project/ui/screens/completed_task_screen.dart';
import 'package:new_project/ui/screens/new_task_screen.dart';
import 'package:new_project/ui/screens/progress_task_screen.dart';

import '../../Widget/tm_app_bar.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedindex = 0;
  List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
  ];


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedindex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedindex,
          onDestinationSelected: (index){
            _selectedindex = index;
            setState(() {});
          },

          destinations:const [
            NavigationDestination(icon: Icon(Icons.new_label), label:"New"),
            NavigationDestination(icon: Icon(Icons.ac_unit_sharp), label:"Progress"),
            NavigationDestination(icon: Icon(Icons.done), label:"Complete"),
            NavigationDestination(icon: Icon(Icons.cancel_outlined), label:"Cancelled"),

          ]),

    );
  }
}