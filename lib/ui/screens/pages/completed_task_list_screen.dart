import 'package:flutter/material.dart';
import 'package:ruhul_ostab_project/ui/controllers/completed_task_list_controller.dart';
import 'package:get/get.dart';
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
  final CompletedTaskListController _completedTaskListController = Get.find<CompletedTaskListController>();

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
      child:GetBuilder<CompletedTaskListController>(
        builder: (controller) {
          return Visibility(
             visible: controller.inProgress == false,
              replacement: CenteredCircularProgressIndicator(),
            child: ListView.builder(
              itemCount: controller.completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskType: TaskType.completed,
                  taskModel: controller.completedTaskList[index],
                  onStatusUpdate: () {
                    _getCompletedTaskList();
                  },
                );
              },
            ),
          );
        }
      ),
    );
  }


  Future<void> _getCompletedTaskList() async {
    final bool isSuccess = await _completedTaskListController.getCompletedTaskList();

    if (isSuccess) {

          return;
    } else {
      if (mounted) {
        showSnackBarMessage(context, _completedTaskListController.errorMessage!);
      }
    }
  }


}