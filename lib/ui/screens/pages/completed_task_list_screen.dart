import 'package:flutter/material.dart';

import '../../../data/models/task_model.dart';
import '../../../data/service/network_caller.dart';
import '../../../data/urls.dart';
import '../../widgets/centered_circular_progress_indicator.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/task_card.dart';


class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _getCompletedTasksInProgress = false;
  List<TaskModel> _CompletedTaskList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCompletedTaskList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child:Visibility(
         visible: _getCompletedTasksInProgress == false,
          replacement: CenteredCircularProgressIndicator(),
        child: ListView.builder(
          itemCount: _CompletedTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskType: TaskType.completed,
              taskModel: _CompletedTaskList[index],
              onStatusUpdate: () {
                _getCompletedTaskList();
              },
            );
          },
        ),
      ),
    );
  }


  Future<void> _getCompletedTaskList() async {
    _getCompletedTasksInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller
        .getRequest(url: Urls.getCompletedTasksUrl);

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _CompletedTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }

    _getCompletedTasksInProgress = false;
    setState(() {});
  }



}