import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:segmentation_helper/pages/home_bloc.dart';
import 'package:segmentation_helper/pages/home_bloc_state.dart';
import 'package:segmentation_helper/pages/rigght_sidebar_cubit.dart';
import 'package:segmentation_helper/pages/right_sidebar_state.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'dart:math' as math;
class RightSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RightSidebarCubit(RightSidebarStateNone()),
      child: RightSidebarContent(),
    );
  }
}

class RightSidebarContent extends StatelessWidget {
  final widthDebouncer =
      Debouncer<String>(Duration(milliseconds: 500), initialValue: '100');
  final heightDebouncer =
      Debouncer<String>(Duration(milliseconds: 500), initialValue: '100');
  final topDebouncer =
      Debouncer<String>(Duration(milliseconds: 500), initialValue: '100');
  final leftDebouncer =
      Debouncer<String>(Duration(milliseconds: 500), initialValue: '100');

  final newCategoryNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    final sidebarCubit = context.read<RightSidebarCubit>();

    widthDebouncer.values.listen((event) {
      final homeState = homeBloc.state as HomeBlocStateLoaded;
      final widthCrop = double.parse(event);
      final newCrop = Rect.fromLTRB(
          homeBloc.controller.cropSize.left,
          homeBloc.controller.cropSize.top,
          homeBloc.controller.cropSize.left + widthCrop,
          homeBloc.controller.cropSize.bottom);
      homeBloc.controller.cropSize = newCrop;
    });

    heightDebouncer.values.listen((event) {
      final homeState = homeBloc.state as HomeBlocStateLoaded;
      final widthCrop = double.parse(event);
      final newCrop = Rect.fromLTRB(
          homeBloc.controller.cropSize.left,
          homeBloc.controller.cropSize.top,
          homeBloc.controller.cropSize.right,
          homeBloc.controller.cropSize.top + widthCrop);
      homeBloc.controller.cropSize = newCrop;
    });

    topDebouncer.values.listen((event) {
      final homeState = homeBloc.state as HomeBlocStateLoaded;
      final widthCrop = double.parse(event);
      final newCrop = Rect.fromLTRB(
          homeBloc.controller.cropSize.left,
          widthCrop,
          homeBloc.controller.cropSize.right,
          widthCrop + homeBloc.controller.cropSize.height);
      homeBloc.controller.cropSize = newCrop;
    });

    leftDebouncer.values.listen((event) {
      final homeState = homeBloc.state as HomeBlocStateLoaded;
      final widthCrop = double.parse(event);
      final newCrop = Rect.fromLTRB(
          widthCrop,
          homeBloc.controller.cropSize.top,
          widthCrop + homeBloc.controller.cropSize.width,
          homeBloc.controller.cropSize.bottom);
      homeBloc.controller.cropSize = newCrop;
    });

    homeBloc.controller.addListener(() {
      sidebarCubit.onCropControllerChanged(homeBloc.controller);
    });

    return BlocBuilder<RightSidebarCubit, RightSidebarState>(
        builder: (builderContext, state) {
      if (state is RightSidebarStateNone) return Column();
      final homeState = context.read<HomeBloc>().state as HomeBlocStateLoaded;
      final loaed = state as RightSidebarStateLoaded;

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Column(
            children: [
              Text("Selected path: ${homeState.path.path}"),
              Text(
                "Rect settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              Text("width"),
              TextField(
                controller:
                    context.read<RightSidebarCubit>().widthTextController,
                onChanged: (text) {
                  widthDebouncer.value = text;
                },
              ),
              Text("height"),
              TextField(
                controller:
                    context.read<RightSidebarCubit>().heightTextController,
                onChanged: (text) {
                  heightDebouncer.value = text;
                },
              ),
              Text("top"),
              TextField(
                controller: context.read<RightSidebarCubit>().topTextController,
                onChanged: (text) {
                  topDebouncer.value = text;
                },
              ),
              Text("left"),
              TextField(
                controller:
                    context.read<RightSidebarCubit>().leftTextController,
                onChanged: (text) {
                  leftDebouncer.value = text;
                },
              ),
            ],
          )),
          SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  "Categories",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              SliverToBoxAdapter(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Selected category ${homeState.selectedCategory ?? ""}"),
                  TextField(
                    controller: newCategoryNameTextController,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () {
                        final name = newCategoryNameTextController.text;
                        context.read<HomeBloc>().addCategory(name);
                      },
                      child: Text("Add category"))
                ],
              )),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: context.read<HomeBloc>().categories.length,
                      (listBuilderContext, index) {
                final item = context.read<HomeBloc>().categories[index];
                return Card(
                    child: Container(
                        height: 40,
                        child: InkWell(
                          child: Text(item),
                          onTap: () {
                            context.read<HomeBloc>().selectCategory(item);
                          },
                        )));
              }))
            ],
          ),
          SliverMainAxisGroup(slivers: [
            SliverToBoxAdapter(
              child: Text(
                "Items",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            SliverToBoxAdapter(
              child: ElevatedButton(
                onPressed: () {
                  context.read<HomeBloc>().addItem();
                },
                child: Text("Add item"),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    childCount: context.read<HomeBloc>().items.length,
                    (listBuilder, index) {
              final item = context.read<HomeBloc>().items[index];
              return Card(
                  child: Container(
                      height: 60,
                      child: InkWell(
                        child: Column(
                          children: [
                            Text("Category: ${item.category}"),
                            Text(
                                "Width: ${item.width.toStringAsFixed(2)}, height: ${item.height.toStringAsFixed(2)}, left: ${item.left.toStringAsFixed(2)}, top: ${item.top.toStringAsFixed(2)}")
                          ],
                        ),
                        onTap: () {
                          // context.read<HomeBloc>().selectCategory(item);
                        },
                      )));
            })),
            SliverToBoxAdapter(
              child: ElevatedButton(onPressed: () {
                context.read<HomeBloc>().saveAsync();
              }, child: Text("Save"),),
            )
          ])
        ],
      );
    });
  }
}
