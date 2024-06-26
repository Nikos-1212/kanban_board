import 'package:flutter/material.dart';
import 'package:task_tracker/src/customr_resources/kanban_card/widgets/board_data.dart';
import '../../rendering/board_overlay.dart';
import '../../utils/log.dart';
import '../reorder_flex/drag_state.dart';
import '../reorder_flex/drag_target_interceptor.dart';
import '../reorder_flex/reorder_flex.dart';
import '../reorder_phantom/phantom_controller.dart';

import 'group_data.dart';

typedef OnGroupDragStarted = void Function(int index);

typedef OnGroupDragEnded = void Function(String groupId);

typedef OnGroupReorder = void Function(
  String groupId,
  int fromIndex,
  int toIndex,
);

typedef AppFlowyBoardCardBuilder = Widget Function(
  BuildContext context,
  AppFlowyGroupData groupData,
  AppFlowyGroupItem item,
  int index
);

typedef AppFlowyBoardHeaderBuilder = Widget? Function(
  BuildContext context,
  AppFlowyGroupData groupData,
);

typedef AppFlowyBoardFooterBuilder = Widget Function(
  BuildContext context,
  AppFlowyGroupData groupData,
);

abstract class AppFlowyGroupDataDataSource implements ReoderFlexDataSource {
  AppFlowyGroupData get groupData;

  List<String> get acceptedGroupIds;

  @override
  String get identifier => groupData.id;

  @override
  List<AppFlowyGroupItem> get items => groupData.items;
  // UnmodifiableListView<AppFlowyGroupItem> get items => groupData.items;

  void debugPrint() {
    String msg = '[$AppFlowyGroupDataDataSource] $groupData data: ';
    for (final element in items) {
      msg = '$msg$element,';
    }

    Log.debug(msg);
  }
}

/// A [AppFlowyBoardGroup] represents the group UI of the Board.
///
class AppFlowyBoardGroup extends StatefulWidget {
  const AppFlowyBoardGroup({
    super.key,
    required this.cardBuilder,
    required this.onReorder,
    required this.dataSource,
    required this.phantomController,
    required this.groupWidth,
    required this.onMoveGroupItem,
    required this.onMoveGroupItemToGroup,
    this.headerBuilder,
    this.footerBuilder,
    this.reorderFlexAction,
    this.dragStateStorage,
    this.dragTargetKeys,
    this.scrollController,
    this.onDragStarted,
    this.onDragEnded,
    this.margin = EdgeInsets.zero,
    this.bodyPadding = EdgeInsets.zero,
    this.cornerRadius = 0.0,
    this.backgroundColor = Colors.transparent,
    this.stretchGroupHeight = true, required  this.dataController,
  }) : config = const ReorderFlexConfig();

  final OnMoveGroupItem?  onMoveGroupItem;
  final OnMoveGroupItemToGroup? onMoveGroupItemToGroup;
  final AppFlowyBoardController dataController;
  final AppFlowyBoardCardBuilder cardBuilder;
  final OnGroupReorder onReorder;
  final AppFlowyGroupDataDataSource dataSource;
  final BoardPhantomController phantomController;
  final double groupWidth;
  final AppFlowyBoardHeaderBuilder? headerBuilder;
  final AppFlowyBoardFooterBuilder? footerBuilder;
  final ReorderFlexAction? reorderFlexAction;
  final DraggingStateStorage? dragStateStorage;
  final ReorderDragTargetKeys? dragTargetKeys;

  final ScrollController? scrollController;
  final OnGroupDragStarted? onDragStarted;

  final OnGroupDragEnded? onDragEnded;
  final EdgeInsets margin;
  final EdgeInsets bodyPadding;
  final double cornerRadius;
  final Color backgroundColor;
  final bool stretchGroupHeight;
  final ReorderFlexConfig config;

  String get groupId => dataSource.groupData.id;

  @override
  State<AppFlowyBoardGroup> createState() => _AppFlowyBoardGroupState();
}

class _AppFlowyBoardGroupState extends State<AppFlowyBoardGroup> {
  final GlobalKey _columnOverlayKey =
      GlobalKey(debugLabel: '$AppFlowyBoardGroup overlay key');
  late BoardOverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();

    _overlayEntry = BoardOverlayEntry(
      builder: (BuildContext context) {        
        // final children = widget.dataSource.groupData.items
        //     .map((item) => _buildWidget(context, item))
        //     .toList();
            final children = List.generate(
  widget.dataSource.groupData.items.length,
  (index) => _buildWidget(context, widget.dataSource.groupData.items[index], index),
);
// final children = widget.dataSource.groupData.items
//     .asMap()
//     .entries
//     .map((entry) => _buildWidget(context, entry.value, entry.key))
//     .toList();



        final header =
            widget.headerBuilder?.call(context, widget.dataSource.groupData);

        final footer =
            widget.footerBuilder?.call(context, widget.dataSource.groupData);

        final interceptor = CrossReorderFlexDragTargetInterceptor(
          reorderFlexId: widget.groupId,
          delegate: widget.phantomController,
          acceptedReorderFlexIds: widget.dataSource.acceptedGroupIds,
          draggableTargetBuilder: PhantomDraggableBuilder(),
        );

        final reorderFlex = Flexible(
          fit: widget.stretchGroupHeight ? FlexFit.tight : FlexFit.loose,
          child: Padding(
            padding: widget.bodyPadding,
            child: ReorderFlex(
              key: ValueKey(widget.groupId),
              dragStateStorage: widget.dragStateStorage,
              dragTargetKeys: widget.dragTargetKeys,
              scrollController: widget.scrollController,
              config: widget.config,
              groupWidth: widget.groupWidth,
              onDragStarted: (index) {
                widget.phantomController.groupStartDragging(widget.groupId);
                widget.onDragStarted?.call(index);
              },
              onReorder: (fromIndex, toIndex) {
                if (widget.phantomController.shouldReorder(widget.groupId)) {
                  widget.onReorder(widget.groupId, fromIndex, toIndex);
                  widget.phantomController.updateIndex(fromIndex, toIndex);
                }
              },
              onDragEnded: () {
                widget.phantomController.groupEndDragging(widget.groupId);
                widget.onDragEnded?.call(widget.groupId);
                widget.dataSource.debugPrint();
              },
              dataSource: widget.dataSource,
              interceptor: interceptor,
              reorderFlexAction: widget.reorderFlexAction,
              children: children,
            ),
          ),
        );

 
        return Container(
          margin: widget.margin,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.cornerRadius),
          ),
          child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (header != null) header,
              reorderFlex,
              if (footer != null) footer,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => BoardOverlay(
        key: _columnOverlayKey,
        initialEntries: [_overlayEntry],
      );

  Widget _buildWidget(BuildContext context, AppFlowyGroupItem item,int index) {
    if (item is PhantomGroupItem) {
      return PassthroughPhantomWidget(
        key: UniqueKey(),
        opacity: widget.config.draggingWidgetOpacity,
        passthroughPhantomContext: item.phantomContext,
      );
    }

    return widget.cardBuilder(context, widget.dataSource.groupData, item,index);
  }


}
