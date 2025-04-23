import 'package:flutter/material.dart';
import 'package:new_project/Widget/screen_background.dart';
import 'package:new_project/Widget/tm_app_bar.dart';
import 'package:new_project/data/service/network_client.dart';
import 'package:new_project/widget/centered_progress_circular_indicator.dart';
import 'package:new_project/widget/snack_bar_message.dart';

import '../../data/utils/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(child:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                Text("Add New Task",
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                ),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: "Title"
                  ),
                  validator: (String?value) {
                    if (value
                        ?.trim()
                        .isEmpty ?? true) {
                      return "Enter your valid title";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                      hintText: "Description",
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8)
                  ),
                  validator: (String?value) {
                    if (value
                        ?.trim()
                        .isEmpty ?? true) {
                      return "Enter your valid description";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                Visibility(
                  visible: _addNewTaskInProgress == false,
                  replacement: CenteredProgressCircularIndicator(),
                  child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(Icons.arrow_circle_right_outlined, size: 20,)),
                ),

              ],
            ),
          ),
        ),
      )
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody = {
      "title": _titleController.text.trim(),
      "description":_descriptionController.text.trim(),
      "status":"New"
    };

    final NetworkResponse response = await
    NetworkClient.postRequest(url:Urls.createTaskUrl,body: requestBody);

    _addNewTaskInProgress = false;
    setState(() {});

    if(response.isSuccess){
      clearTextFields();
      showSnackBarMessage(context, "New task added!");
    }else{
      showSnackBarMessage(context,response.errorMessage);
    }
  }

void clearTextFields(){
    _titleController.clear();
    _descriptionController.clear();
}
@override
  void dispose() {
   _titleController.dispose();
   _descriptionController.dispose();
    super.dispose();
  }
}