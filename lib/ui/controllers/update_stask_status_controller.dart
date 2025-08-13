import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhul_ostab_project/data/service/network_caller.dart';
import 'package:ruhul_ostab_project/data/urls.dart';

import '../../data/models/task_model.dart';
import '../widgets/task_card.dart';

class UpdateStaskStatusController extends GetxController{

  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;



  // // TODO: Complete this
  // void _onTapTaskStatus(TaskType type) {
  //   if (type == widget.taskType) {
  //     return;
  //   }
  //
  // }

  Future<void> UpdateTaskStatus(TaskModel taskModel,String status) async {
    // Navigator.pop(context);
    Get.back();

    _inProgress = true;
     update();


    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(taskModel.id, status),
    );

    _inProgress = false;
    update();


    if (response.isSuccess) {
     return;
    } else {
      _errorMessage =response.errorMessage!;

    }
  }




  // Future<void> UpdateTaskStatus(String id,String status) async {
  //   // Navigator.pop(context);
  //   Get.back();
  //
  //   _inProgress = true;
  //   update();
  //
  //   var widget;
  //   NetworkResponse response = await NetworkCaller.getRequest(
  //     url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
  //   );
  //
  //   _inProgress = false;
  //   update();
  //
  //
  //   if (response.isSuccess) {
  //     var widget;
  //     widget.onStatusUpdate();
  //   } else {
  //
  //
  //     _errorMessage =response.errorMessage!;
  //
  //   }
  // }
  //
  //


}