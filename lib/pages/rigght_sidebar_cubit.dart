import 'package:crop_image/src/crop_controller.dart';
import 'package:segmentation_helper/pages/right_sidebar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class RightSidebarCubit extends Cubit<RightSidebarState> {
  final widthTextController = TextEditingController();
  final heightTextController = TextEditingController();
  final topTextController = TextEditingController();
  final leftTextController = TextEditingController();

  RightSidebarCubit(super.initialState){
  }

  void onCropControllerChanged(CropController controller) {
    try {
      widthTextController.text = controller.cropSize.width.toString();
      heightTextController.text = controller.cropSize.height.toString();
      topTextController.text = controller.cropSize.top.toString();
      leftTextController.text = controller.cropSize.left.toString();

      final newState = RightSidebarStateLoaded(width: controller.cropSize.width, height: controller.cropSize.height, top: controller.cropSize.top, left: controller.cropSize.left);
      emit(newState);
    } catch(e) {

    }
  }

}