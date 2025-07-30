import 'package:flutter/material.dart';
import 'package:ruhul_ostab_project/ui/controllers/progress_task_list_controller.dart';



import '../../controllers/new_task_list_controller.dart';
import '../../widgets/centered_circular_progress_indicator.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/task_card.dart';
import 'package:get/get.dart';




class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {

     final ProgressTaskListController _progressTaskListController = Get.find<ProgressTaskListController>();
//  final ProgressTaskListController _progressTaskListController = ProgressTaskListController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProgressTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GetBuilder<ProgressTaskListController>(
        builder: (controller) {
          return Visibility(
            visible: controller.inProgress == false,
            replacement: CenteredCircularProgressIndicator(),
            child: ListView.builder(
              itemCount: controller.progressTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskType: TaskType.progress,
                  taskModel: controller.progressTaskList[index],
                  onStatusUpdate: () {
                    getProgressTaskList();
                  },
                );
              },
            ),
          );
        }
      ),
    );
  }


  Future<void> getProgressTaskList() async {

    final bool isSuccess = await _progressTaskListController.getProgressTaskList();

    if (isSuccess) {


    } else {
      if (mounted) {
        showSnackBarMessage(context, _progressTaskListController.errorMessage!);
      }
    }
  }
}