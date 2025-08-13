import 'package:flutter/material.dart';
import 'package:ruhul_ostab_project/ui/controllers/delete_task_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/new_task_list_controller.dart';
import 'package:ruhul_ostab_project/ui/controllers/update_stask_status_controller.dart';
import 'package:ruhul_ostab_project/ui/widgets/snack_bar_message.dart';
import 'package:get/get.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import 'centered_circular_progress_indicator.dart';

enum TaskType { tNew , progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskType,
    required this.taskModel,
    required this.onStatusUpdate
  });



  final TaskType taskType;
  final TaskModel taskModel;
  final VoidCallback onStatusUpdate;

  @override
  State<TaskCard> createState() => _TaskCardState();
}



class _TaskCardState extends State<TaskCard> {
  bool _updateTaskStatusInProgress = false;
  bool _deleteTaskInProgress =false;

  final UpdateStaskStatusController _updateStaskStatusController = Get.find<UpdateStaskStatusController>();
  final DeleteTaskController _deleteTaskController = Get.find<DeleteTaskController>();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              widget.taskModel.description,
              style: TextStyle(color: Colors.black54),
            ),
            Text('Date: ${widget.taskModel.createdDate}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    _getTaskTypeName(),
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: _getTaskChipColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                ),
                Spacer(), Visibility(
                  visible: _deleteTaskInProgress == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: IconButton(onPressed: () {
                    _showDeleteDialog();
                  }, icon: Icon(Icons.delete)),
                ),
                Visibility(
                  visible: _updateTaskStatusInProgress == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () {
                      _showEditTaskStatusDialog();
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Color _getTaskChipColor() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return Colors.blue;
      case TaskType.progress:
        return Colors.purple;
      case TaskType.completed:
        return Colors.green;
      case TaskType.cancelled:
        return Colors.red;
    }
  }





  String _getTaskTypeName() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return 'New';
      case TaskType.progress:
        return 'Progress';
      case TaskType.completed:
        return 'Completed';
      case TaskType.cancelled:
        return 'Cancelled';
    }
  }







  void _showDeleteDialog(){
    showDialog(context: context, builder: (context)=>SimpleDialog(
      title: Text(
          'Are you confirmed to delete?',style: TextStyle(fontSize: 16),
      ),
      children: [
       Row(
         children: [
           Expanded(
             child: SimpleDialogOption(
               child: Text('No'),
               onPressed: ()=>Navigator.pop(context),
             ),
           ),
           SimpleDialogOption(
             child: Text('Yes'),
             onPressed: _deleteTaskbyId,
           )
         ],

       )

      ],
    ));
  }






  Future<void> _deleteTaskbyId() async {
       bool isSuccess = await _deleteTaskController.DeleteTaksk(widget.taskModel.id);

      if (isSuccess)
        {
          Navigator.pop(context);
          Get.find<NewTaskListController>().getNewTaskList();
          Get.find<NewTaskListController>().getTaskStatusCountList();

          if(mounted)
          {
            showSnackBarMessage(context,"Task Deleted Successfully");
          }
          return;
        }
      else
        {
          if(mounted)
            {
              showSnackBarMessage(context,const Response().body);
            }

        }


  }


  void _showEditTaskStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('New'),
                trailing: _getTaskStatusTrailing(TaskType.tNew),
                onTap: () {
                  if (widget.taskType == TaskType.tNew) {
                    return;
                  }
                  _updateTaskStatus('New');
                },
              ),
              ListTile(
                title: Text('In Progress'),
                trailing: _getTaskStatusTrailing(TaskType.progress),
                onTap: () {
                  if (widget.taskType == TaskType.progress) {
                    return;
                  }
                  _updateTaskStatus('Progress');
                },
              ),
              ListTile(
                title: Text('Completed'),
                trailing: _getTaskStatusTrailing(TaskType.completed),
                onTap: () {
                  if (widget.taskType == TaskType.completed) {
                    return;
                  }
                  _updateTaskStatus('Completed');
                },
              ),
              ListTile(
                title: Text('Cancelled'),
                trailing: _getTaskStatusTrailing(TaskType.cancelled),
                onTap: () {
                  if (widget.taskType == TaskType.cancelled) {
                    return;
                  }
                  _updateTaskStatus('Cancelled');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _getTaskStatusTrailing(TaskType type) {
    return widget.taskType == type ? Icon(Icons.check) : null;
  }

  // // TODO: Complete this
  // void _onTapTaskStatus(TaskType type) {
  //   if (type == widget.taskType) {
  //     return;
  //   }
  //
  // }





  Future<void> _updateTaskStatus(String status) async {
    // Navigator.pop(context);
    Get.back();

    _updateTaskStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );

    _updateTaskStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      widget.onStatusUpdate();
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage!);
      }
    }
  }






//
// Future<void> _updateTaskStatus(String status) async {
//    // Navigator.pop(context);
//     Get.back();
//
//     _updateTaskStatusInProgress = true;
//     if (mounted) {
//       setState(() {});
//     }
//
//     NetworkResponse response = await NetworkCaller.getRequest(
//       url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
//     );
//
//     _updateTaskStatusInProgress = false;
//     if (mounted) {
//       setState(() {});
//     }
//
//     if (response.isSuccess) {
//       widget.onStatusUpdate();
//     } else {
//       if (mounted) {
//         showSnackBarMessage(context, response.errorMessage!);
//       }
//     }
//   }






}