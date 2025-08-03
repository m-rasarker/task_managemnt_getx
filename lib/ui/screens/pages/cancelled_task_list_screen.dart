import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhul_ostab_project/ui/widgets/centered_circular_progress_indicator.dart';
import '../../../data/models/task_model.dart';
import '../../../data/service/network_caller.dart';
import '../../../data/urls.dart';
import '../../controllers/cancelled_task_list_controller.dart';
import '../../controllers/progress_task_list_controller.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/task_card.dart';


class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {

  final CancelledTaskListController _cancelledTaskListController = Get.find<CancelledTaskListController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCancelledTaskList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GetBuilder<CancelledTaskListController>(
        builder: (controller) {
          return Visibility(
            visible: controller.inProgress == false,
            replacement: CenteredCircularProgressIndicator(),
            child: ListView.builder(
              itemCount: controller.cancelledTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskType: TaskType.cancelled,
                  taskModel: controller.cancelledTaskList[index],
                  onStatusUpdate: () {
                    _getCancelledTaskList();
                  },
                );
              },
            ),
          );
        }
      ),
    );
  }

  Future<void> _getCancelledTaskList() async {
    final bool isSuccess = await _cancelledTaskListController.getCancelledTaskList();

    if (isSuccess) {
          return;

    } else {
      if (mounted) {
        showSnackBarMessage(context, _cancelledTaskListController.errorMessage!);
      }
    }
  }



}