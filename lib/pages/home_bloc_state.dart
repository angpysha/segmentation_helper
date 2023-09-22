import 'dart:io';

import 'package:segmentation_helper/pages/tiff_dataset.dart';

sealed class HomeBlocState {}

class HomeBlocStateNone extends HomeBlocState {}

class HomeBlocStateLoaded extends HomeBlocState {
  HomeBlocStateLoaded(
      {required this.path,
      required this.width,
      required this.height,
      required this.displayImagePath,
      this.dataset,
      this.selectedCategory});

  final File displayImagePath;
  final Directory path;
  final int width;
  final int height;
  final String? selectedCategory;
  final TiffDataset? dataset;

  HomeBlocStateLoaded copyWith(
      {File? displayImagePath,
      Directory? path,
      int? width,
      int? height,
      TiffDataset? dataset,
      String? selectedCategory}) {
    return HomeBlocStateLoaded(
        displayImagePath: displayImagePath ?? this.displayImagePath,
        path: path ?? this.path,
        width: width ?? this.width,
        height: height ?? this.height,
        dataset: dataset ?? this.dataset,
        selectedCategory: selectedCategory ?? this.selectedCategory);
  }
}
