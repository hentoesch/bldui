import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'json_designer.dart';
import 'package:bldui/common/types.dart';
import 'package:bldui/common/globals.dart' as glob;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bldui/bloc/bloc.dart';

class UiDesigner extends StatefulWidget {
  List<(Rect, Color, String, dynamic, DesignItemType)> itemRecords;
  Map model;
  double totalLines;
  Function modelChanged;
  UIdesignerType uiDesignerType;
  UiDesigner(
      {required this.itemRecords,
      required this.model,
      required this.totalLines,
      required this.modelChanged,
      required this.uiDesignerType,
      Key? key})
      : super(key: key);

  @override
  State<UiDesigner> createState() => _UiDesignerState();
}

class _UiDesignerState extends State<UiDesigner> {
  var _overlayController = OverlayPortalController();
  //static const containerWidth = 90.0;
  static const kGrid = 20.0;
  //static const kGrid = 40.0;
  static final kNormalizedRect =
      Rect.fromCircle(center: Offset.zero, radius: 1);
  List<Item> items = [];
  var designBloc;
  bool layoutChanged = false;

  ///
  /// the container
  ///
  var container;
  @override
  void initState() {
    super.initState();
    double height = widget.totalLines * 2;
    container = Rect.fromLTWH(0, 0, glob.containerWidth, height);
    //TODO: implement initState
    items = widget.itemRecords
        .map((r) => Item(
            initialRect: r.$1,
            color: r.$2,
            debugName: r.$3,
            container: container,
            cargo: r.$4,
            designItemType: r.$5))
        .toList();
    // for (var itm in widget.items) {
    //   itm.container = container;
    // }
  }

  final sizerData = [
    (Alignment.centerLeft, (Offset d) => EdgeInsets.only(left: -d.dx)),
    (Alignment.topCenter, (Offset d) => EdgeInsets.only(top: -d.dy)),
    (Alignment.centerRight, (Offset d) => EdgeInsets.only(right: d.dx)),
    (Alignment.bottomCenter, (Offset d) => EdgeInsets.only(bottom: d.dy)),
  ];
  Item? _activeItem;
  bool layoutAll = true;
  bool clamp = false;
  bool showJsonEditor = false;
  var editModel;
  @override
  Widget build(BuildContext context) {
    designBloc = BlocProvider.of<DesignBloc>(context);

    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: container.width * kGrid,
          child: Column(
            children: [
              if (showJsonEditor)
                OverlayPortal(
                  overlayChildBuilder: (context) => Positioned(
                      top: 100,
                      left: 100,
                      child: Center(
                        child: JsonDesigner(
                            model: _activeItem!.cargo,
                            onButtonPressed: (String button, newModel) {
                              if (button == "save") {
                                _activeItem!.cargo = newModel;
                                widget.modelChanged(
                                    newModel, _activeItem!.designItemType);
                                // for (var r in widget.itemRecords) {
                                //   if (r.$3 == newModel['name']) {
                                //     r. = newModel;
                                //   }
                                // }
                              }
                              _overlayController.hide();
                              showJsonEditor = false;
                              setState(() {});
                            },
                            key: UniqueKey()),
                      )),
                  controller: _overlayController,
                ),

              SizedBox.fromSize(
                size: container.size * kGrid,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GridPaper(
                        subdivisions: 1,
                        interval: kGrid,
                        color: Colors.black38,
                        child: GestureDetector(
                          onTap: () => setState(() => _activeItem = null),
                        ),
                      ),
                    ),
                    ...items.map(_itemBuilder),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 32,
                    child: Row(children: [
                      if (layoutChanged)
                        ElevatedButton(
                            onPressed: () {
                              _itemCheckForUpdate(items);
                              // designBloc.add(DesignFieldChangeEvent(
                              //     fieldName: _activeItem!.debugName,
                              //     fieldAction: FieldAction.removeField));
                              // _activeItem = null;
                              //setState();
                            },
                            child: Text('Update Model')),
                      if (_activeItem != null)
                        ElevatedButton(
                            onPressed: () {
                              designBloc.add(DesignFieldChangeEvent(
                                  fieldName: _activeItem!.debugName,
                                  fieldAction: FieldAction.removeField));
                              _activeItem = null;
                              //setState();
                            },
                            child: Text('Remove Column')),
                    ])),
              ),

              // Align(
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       mainAxisSize: MainAxisSize.max,
              //       children: [
              //         ElevatedButton(
              //             child: Text("Save"),
              //             onPressed: () {
              //               widget.onButtonPressed("save");
              //               // _formKey.currentState?.saveAndValidate();
              //               // formBloc.add(FormPersistDataEvent());
              //               // Navigator.pop(context, true);
              //             }),
              //         ElevatedButton(
              //             child: Text("Cancel"),
              //             onPressed: () {
              //               widget.onButtonPressed("cancel");
              //               //Navigator.pop(context, false);
              //             }),
              //       ]),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(Item item) {
    final isActive = item == _activeItem;
    print("build ${item.debugName},${item.rect}");
    //return AnimatedPositioned.fromRect(
    return Positioned.fromRect(
      key: ObjectKey(item),
      //duration: Durations.short4,
      rect: item.rect * kGrid,
      child: Stack(
        children: [
          // item itself
          Positioned.fill(
            child: AnimatedContainer(
              duration: Durations.medium4,
              foregroundDecoration: BoxDecoration(
                color: isActive ? Colors.grey.withOpacity(0.2) : null,
              ),
              decoration: BoxDecoration(
                boxShadow: isActive
                    ? const [BoxShadow(blurRadius: 4, offset: Offset(3, 3))]
                    : null,
              ),
              child: GestureDetector(
                onSecondaryTap: () {
                  // right moiuse button
                  if (_activeItem != null) {
                    print('active item cargo: ${_activeItem!.cargo}');
                    _overlayController.show();
                    showJsonEditor = true;
                    setState(() {});
                    //widget.onEdit(_activeItem!.cargo);
                  }
                },
                onTap: () => setState(() {
                  _restack(item);
                  _activeItem = isActive ? null : item;
                  if (_activeItem != null) {
                    print('active item cargo: ${_activeItem!.cargo}');
                    // widget.modelChanged(
                    //     _activeItem!.cargo, DesignItemType.formField);
                    // setState(() {});
                    // designBloc.add(DesignFieldChangeEvent(
                    //     fieldName: _activeItem!.debugName,
                    //     fieldAction: FieldAction.selectField));
                  }
                }),
                onPanStart: (d) => setState(() {
                  _restack(item);
                  _activeItem = item;
                }),
                onPanUpdate: (d) {
                  if (item.moveBy(d.delta / kGrid, clamp)) {
                    debugPrint(
                        '"${item.debugName}" moved to ${item.location(false)}');
                    //_relayout(container, item, items, layoutAll);
                    layoutChanged = true;
                    //_itemCheckForUpdate(items);
                    setState(() {});
                  }
                },
                onPanEnd: (d) => item.settle(),
                child: item.build(isActive),
              ),
            ),
          ),
          // four sizers
          ...sizerData.map((sizerRecord) {
            final (alignment, insetBuilder) = sizerRecord;
            return ClipRect(
              child: Align(
                alignment: alignment,
                child: SizedBox.fromSize(
                  size: const Size.square(kGrid / sqrt2),
                  child: AnimatedSlide(
                    duration: Durations.medium4,
                    offset: alignment.withinRect(kNormalizedRect) *
                        (isActive ? 0.75 : 1),
                    curve: Curves.easeOut,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.5),
                        border: Border.all(color: Colors.black, width: 1),
                        shape: BoxShape.rectangle,
                      ),
                      child: GestureDetector(
                        onPanUpdate: (d) {
                          if (item.inflateBy(
                              insetBuilder(d.delta / kGrid), clamp)) {
                            debugPrint(
                                '"${item.debugName}" resized to ${item.location(true)}');
                            _relayout(container, item, items, layoutAll);

                            setState(() {});
                          }
                        },
                        onPanEnd: (d) => item.settle(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List para = [];
  List line = [];
  List<dynamic> col = [];

  _itemCheckForUpdate(List<Item> items) {
    double top = 0;
    if (widget.uiDesignerType == UIdesignerType.list) {
      for (int i = 0; i < widget.totalLines; i++) {
        for (var j = 2; j < glob.containerWidth; j++) {
          for (var itm in items) {
            if (itm.rect.left == j && itm.rect.top == top) {
              col.add(itm.cargo);
            }
          }
        }
        line.add(col);
        para.add(line);
        line = [];
        top += 2;
      }
      widget.modelChanged(para, DesignItemType.Layout);
    } else if (widget.uiDesignerType == UIdesignerType.form) {
      var newFields = [];
      double top = 2;
      double left = 2;
      for (int i = 0; i < (widget.totalLines * 2); i++) {
        for (var j = 0; j < glob.containerWidth; j++) {
          for (var itm in items) {
            //print("i=$i, j=$j,left=${itm.rect.left}, top=${itm.rect.top}");
            if (itm.rect.left == j && itm.rect.top == top) {
              var cg = Map.from(itm.cargo);
              cg['row'] = (top / 2).toInt();
              cg['col'] = (j / 2).toInt();
              newFields.add(cg);
            }
          }
          left += 2;
        }
        left = 2;
        top += 2;
        //line.add(col);
      }
      widget.modelChanged(newFields, DesignItemType.Layout);
    }
  }

  _relayout(Rect container, Item fixedItem, List<Item> items, bool layoutAll) {
    final fixedItemRect = fixedItem.rect;
    final remainingItems = items.where((i) => i != fixedItem).toList();

    final itemsToLayout = layoutAll
        ? remainingItems
        : remainingItems.where((i) => i._rect.overlaps(fixedItemRect));
    final itemsNotToLayout = layoutAll
        ? <Item>[]
        : remainingItems.where((i) => !i._rect.overlaps(fixedItemRect));

    int byLongestSide(Item a, Item b) =>
        -a._rect.longestSide.compareTo(b._rect.longestSide);
    // int byDiagonal(Item a, Item b) => -a._rect.size.bottomRight(Offset.zero).distance.compareTo(b._rect.size.bottomRight(Offset.zero).distance);
    // int byHeight(Item a, Item b) => -a._rect.height.compareTo(b._rect.height);

    final sortedItems = itemsToLayout.sorted(byLongestSide);
    // debugPrint('sortedItems: ${sortedItems.map((item) => item.debugName)}}');

    final placedItems = <Item, Rect>{
      fixedItem: fixedItemRect,
      for (final item in itemsNotToLayout) item: item._rect,
    };
    itemLoop:
    for (final item in sortedItems) {
      for (double t = container.top;
          t < container.bottom - item._rect.height + 1;
          t++) {
        for (double l = container.left;
            l < container.right - item._rect.width + 1;
            l++) {
          final r = Rect.fromLTWH(l, t, item._rect.width, item._rect.height);
          final goodPlaceToLay =
              placedItems.values.every((i) => !i.overlaps(r));
          if (goodPlaceToLay) {
            // debugPrint('good place to lay for ${item.debugName} is $r');
            item._rect = r;
            placedItems[item] = r;
            continue itemLoop;
          }
        }
      }
      debugPrint('no space for ${item.debugName}');
    }
  }

  void _restack(Item item) {
    items
      ..remove(item)
      ..add(item);
    debugPrint('new order: ${items.map((item) => item.debugName)}');
  }
}

extension RectUtilExtension on Rect {
  Rect snap(double grid) {
    final l = (left / grid).roundToDouble() * grid;
    final t = (top / grid).roundToDouble() * grid;
    final r = (right / grid).roundToDouble() * grid;
    final b = (bottom / grid).roundToDouble() * grid;

    return Rect.fromLTRB(l, t, r, b);
  }

  Rect clamp(Rect container) {
    // assert(width <= container.width && height <= container.height);
    double l = max(left, container.left);
    double t = max(top, container.top);
    if (right > container.right) l -= right - container.right;
    if (bottom > container.bottom) t -= bottom - container.bottom;

    // l == left && t == top means that no clamping was done so return 'this' Rect
    return l == left && t == top ? this : Rect.fromLTWH(l, t, width, height);
  }

  Rect operator *(double operand) => Rect.fromLTRB(
      left * operand, top * operand, right * operand, bottom * operand);
}

class Item {
  Item({
    required Rect initialRect,
    required this.color,
    required this.debugName,
    required this.container,
    required this.cargo,
    required this.designItemType,
  }) : _rect = initialRect;

  Rect _rect;
  final Color color;
  final String debugName;
  Rect container;
  //final List<Map<String, dynamic>> cargo;
  dynamic cargo;
  DesignItemType designItemType;
  // snapped Rect
  Rect get rect => _rect.snap(1);

  bool moveBy(Offset delta, bool clamp) {
    final old = rect;
    _rect = _rect.shift(delta);
    if (clamp) _clamp(old, false);
    return old != rect;
  }

  bool inflateBy(EdgeInsets insets, bool clamp) {
    final old = rect;
    _rect = insets.inflateRect(_rect);
    if (clamp) _clamp(old, true);
    return old != rect;
  }

  _clamp(Rect old, bool resize) {
    if (old == rect) return;

    if (resize) {
      if (_rect!.expandToInclude(container) != container) {
        _rect = old;
      }
    } else {
      _rect = _rect.clamp(container);
    }
  }

  settle() => _rect = rect;

  Widget build(bool isActive) => Container(
        padding: const EdgeInsets.all(4),

        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.grey, border: Border.all(color: Colors.blue)),
        //decoration: BoxDecoration(
        //gradient: RadialGradient(
        //  colors: [Color.alphaBlend(Colors.white30, color), color],
        //  radius: 1,
        //),
        //),
        child: Text(debugName,
            style: TextStyle(color: isActive ? Colors.white : Colors.black)),
        // child: FittedBox(
        //     child:
        //         Text(debugName, style: const TextStyle(color: Colors.white70))),
      );

  String location(bool reportSize) {
    final r = rect;
    final position = r.topLeft;
    final size = r.size;
    final positionStr = '(${position.dx.toInt()},${position.dy.toInt()})';
    return switch (reportSize) {
      true => '${size.width.toInt()}x${size.height.toInt()} at $positionStr',
      false => positionStr,
    };
  }
}
// List<(Rect, Color, String, dynamic)> items = [
//   (
//     const Rect.fromLTWH(0, 0, 2, 1),
//     Colors.grey,
//     attributeData[0][0]['name'],
//     attributeData[0]
//   ),
//   (
//     const Rect.fromLTWH(2, 0, 2, 1),
//     Colors.grey,
//     attributeData[1][0]['name'],
//     attributeData[1]
//   ),
//   (
//     const Rect.fromLTWH(4, 0, 4, 1),
//     Colors.grey,
//     attributeData[2][0]['name'],
//     attributeData[2]
//   ),
//   // (const Rect.fromLTWH(0, 2, 3, 1), Colors.deepPurple, 'deep purple'),
//   // (const Rect.fromLTWH(3, 1, 1, 2), Colors.red.shade800, 'red'),
//   // (const Rect.fromLTWH(2, 1, 1, 1), Colors.teal, 'teal'),
// ];
// final List<(Rect, Color, String)> items = [
//   (const Rect.fromLTWH(0, 0, 2, 2), Colors.grey, 'indigo'),
//   (const Rect.fromLTWH(2, 0, 2, 1), Colors.orange.shade800, 'orange'),
//   (const Rect.fromLTWH(4, 0, 1, 3), Colors.pink, 'pink'),
//   (const Rect.fromLTWH(0, 2, 3, 1), Colors.deepPurple, 'deep purple'),
//   (const Rect.fromLTWH(3, 1, 1, 2), Colors.red.shade800, 'red'),
//   (const Rect.fromLTWH(2, 1, 1, 1), Colors.teal, 'teal'),
// ];
// .map((r) => Item(
//     initialRect: r.$1,
//     color: r.$2,
//     debugName: r.$3,
//     container: container))
// .toList();
// late final items = [
//   (const Rect.fromLTWH(0, 0, 2, 2), Colors.indigo, 'indigo'),
//   (const Rect.fromLTWH(2, 0, 2, 1), Colors.orange.shade800, 'orange'),
//   (const Rect.fromLTWH(4, 0, 1, 3), Colors.pink, 'pink'),
//   (const Rect.fromLTWH(0, 2, 3, 1), Colors.deepPurple, 'deep purple'),
//   (const Rect.fromLTWH(3, 1, 1, 2), Colors.red.shade800, 'red'),
//   (const Rect.fromLTWH(2, 1, 1, 1), Colors.teal, 'teal'),
// ]
// .map((r) => Item(
//     initialRect: r.$1,
//     color: r.$2,
//     debugName: r.$3,
//     container: container))
// .toList();

// List<(Rect, Color, String, dynamic)> testItems = [];
// final List<List<Map<String, dynamic>>> attributeData = [
//   [
//     {"name": "sim_id"},
//     {"width": 20.0}
//   ],
//   [
//     {"name": "sim_name"},
//     {"width": 40.0}
//   ],
//   [
//     {"name": "sim_bemerkung"},
//     {"width": 80.0}
//   ],
// ];
// void _prepItems() {
//   double left = 0;
//   double len = 0;
//   for (var i = 0; i < attributeData!.length; i++) {
//     len = (attributeData[i][1]['width'] / 20);
//     testItems.add((
//       Rect.fromLTWH(left, 0, len, 1),
//       Colors.grey,
//       attributeData[i][0]['name'],
//       attributeData[i]
//     ));
//     left += (attributeData[i][1]['width'] / 10);
//   }
// }

// void main() {
//   _prepItems();
//   runApp(MaterialApp(
//       home: Scaffold(
//           body: UiDesigner(
//     itemRecords: testItems,
//   ))));
// }
