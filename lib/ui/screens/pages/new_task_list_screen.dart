import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/models/task_status_count_model.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';
import 'package:ruhul_ostab_project/ui/controllers/new_task_list_controller.dart';
import 'package:ruhul_ostab_project/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:ruhul_ostab_project/ui/widgets/snack_bar_message.dart';
import 'package:ruhul_ostab_project/ui/widgets/task_card.dart';
import 'package:ruhul_ostab_project/ui/widgets/task_count_summary_card.dart';

import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NewTaskListController>().getNewTaskList();
      Get.find<NewTaskListController>().getTaskStatusCountList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: GetBuilder<NewTaskListController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.inProgress== false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ListView.separated(
                      itemCount: controller.TaskStatusCountList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return TaskCountSummaryCard(
                          title: controller.TaskStatusCountList[index].id,
                          count: controller.TaskStatusCountList[index].count,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 4),
                    ),
                  );
                }
              ),
            ),
            Expanded(
              child: GetBuilder<NewTaskListController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.inProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ListView.builder(
                      itemCount: controller.newTaskList.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskType: TaskType.tNew,
                          taskModel: controller.newTaskList[index],
                          onStatusUpdate: () {
                            Get.find<NewTaskListController>().getNewTaskList();
                          //  _getTaskStatusCountList();
                            Get.find<NewTaskListController>().getTaskStatusCountList();

                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }


  void _onTapAddNewTaskButton() {
    // Navigator.pushNamed(context, AddNewTaskScreen.name);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewTaskScreen()));
    // Get.to(() => AddNewTaskScreen());
    Get.toNamed(AddNewTaskScreen.name);
  }
}