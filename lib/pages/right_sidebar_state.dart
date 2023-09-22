
import 'package:segmentation_helper/pages/tiff_dataset.dart';

sealed class RightSidebarState {

}

class RightSidebarStateNone extends RightSidebarState {

}

class RightSidebarStateLoaded extends RightSidebarState {

  RightSidebarStateLoaded({required this.width, required this.height, required this.top, required this.left});

  final double width;
  final double height;
  final double top;
  final double left;
}