import 'dart:convert';
import 'dart:io';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:segmentation_helper/folder_picker_stream.dart';
import 'package:segmentation_helper/pages/home_bloc_state.dart';
import 'package:segmentation_helper/pages/tiff_dataset.dart';
import 'package:path/path.dart';

class HomeBloc extends Cubit<HomeBlocState> {
  final saveName = "dataset.config";

  final controller = CropController(

      /// If not specified, [aspectRatio] will not be enforced.
      /// Specify in percentages (1 means full width and height). Defaults to the full image.
      defaultCrop: Rect.fromLTRB(0.01, 0.01, 0.9, 0.9),
      minimumImageSize: 20);

  HomeBloc(super.initialState) {
    pickerStreamController.stream.listen(_onFolderPicked);
  }

  List<String> get categories {
    if (state is HomeBlocStateLoaded) {
      final stateLoaded = state as HomeBlocStateLoaded;
      return stateLoaded.dataset?.categories ?? [];
    }

    return [];
  }

  List<ImagePart> get items {
    if (state is HomeBlocStateLoaded) {
      final stateLoaded = state as HomeBlocStateLoaded;
      return stateLoaded.dataset?.items ?? [];
    }

    return [];
  }

  void _onFolderPicked(String event) async {
    final directory = Directory(event);

    if (directory.existsSync()) {
      final items = directory.listSync();

      try {
        final itemToDisplay = items.firstWhere(
            (element) => element.path.contains("Optimized_Natural_Color"));

        final file = File(itemToDisplay.path);

        final img = await decodeImageFromList(file.readAsBytesSync());

        //Load config if exists

        final configPath = join(event, saveName);
        final configFile = File(configPath);
        TiffDataset? dataset;
        if (await configFile.exists()) {
          final fileContent = await configFile.readAsString();
          final jsonMap = jsonDecode(fileContent);
          dataset = TiffDataset.fromJson(jsonMap);
        }

        final newState = HomeBlocStateLoaded(
            path: directory,
            width: img.width,
            height: img.height,
            displayImagePath: file,
            dataset: dataset);
        emit(newState);
      } on Exception catch (e) {}
    }
  }

  void addCategory(String name) {
    final currentState = state as HomeBlocStateLoaded;
    TiffDataset? dataset;
    if (currentState.dataset == null) {
      dataset = TiffDataset();
      dataset.categories.add(name);
    } else {
      currentState.dataset?.categories.add(name);
    }

    final newState = currentState.copyWith(dataset: dataset);
    emit(newState);
  }

  void selectCategory(String category) {
    final currentState = state as HomeBlocStateLoaded;
    final newState = currentState.copyWith(selectedCategory: category);
    emit(newState);
  }

  void addItem() {
    final currentState = state as HomeBlocStateLoaded;
    if (currentState.selectedCategory?.isNotEmpty == true) {
      final imagePart = ImagePart(
          controller.cropSize.width,
          controller.cropSize.height,
          controller.cropSize.left,
          controller.cropSize.top,
          currentState.selectedCategory!);
      currentState.dataset!.items.add(imagePart);
      final newState = currentState.copyWith();
      emit(newState);
    }
  }

  Future<void> saveAsync() async {
    final currentState = state as HomeBlocStateLoaded;
    if (currentState.dataset != null) {
      final configPath = join(currentState.path.path, saveName);
      final file = File(configPath);
      if (await file.exists()) {
        await file.delete();
      }

      final jsonMap = currentState.dataset!.toJson();
      final jsonStr = json.encode(jsonMap);

      await file.writeAsString(jsonStr);
    }
  }
}
