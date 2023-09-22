import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:segmentation_helper/pages/home_bloc.dart';
import 'package:segmentation_helper/pages/home_bloc_state.dart';
import 'package:crop_image/crop_image.dart';
import 'package:segmentation_helper/pages/right_sidebar.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(HomeBlocStateNone()),
      child: HomeWidgetContent(),
    );
  }
}

class HomeWidgetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeBlocState>(
      builder: (builderContext, state) {
        return switch (state) {
          HomeBlocStateLoaded loaded =>
            HomeWidgetContentLoaded(loadedState: loaded),
          // TODO: Handle this case.
          HomeBlocStateNone() => Column(),
        };
      },
    );
  }
}

class HomeWidgetContentLoaded extends StatelessWidget {
  HomeWidgetContentLoaded({required this.loadedState});

  final HomeBlocStateLoaded loadedState;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CropImage(
          controller: context.read<HomeBloc>().controller,
          minimumImageSize: 20,
          image: Image.file(loadedState.displayImagePath),
        )),
        //     child: InteractiveViewer(
        //   minScale: 1.0,
        //   maxScale: 1.0,
        //   child: Container(
        //       alignment: Alignment.center,
        //       width: loadedState.width.toDouble(),
        //       height: loadedState.height.toDouble(),
        //       child: Image.file(
        //         loadedState.displayImagePath,
        //         width: loadedState.width.toDouble(),
        //         height: loadedState.height.toDouble(),
        //       )),
        // )),
        SizedBox(width: 350, child: RightSidebar())
      ],
    );
  }
}
