import 'package:bldui/common/types.dart';
import 'package:bldui/common/globals.dart' as glob;
import 'package:bldui/common/template.dart';

import 'package:flutter/material.dart';
import 'ui_designer.dart';
import 'json_designer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bldui/bloc/bloc.dart';

class FormDesigner extends StatefulWidget {
  Map model;
  FormDesigner({required this.model, super.key});

  @override
  State<FormDesigner> createState() => _FormDesignerState();
}

class _FormDesignerState extends State<FormDesigner> {
  var jsonBloc;

  List<(Rect, Color, String, dynamic, DesignItemType)> designItems = [];
  double totalLines = 10;
  bool showJson = false;
  var _overlayController = OverlayPortalController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildFieldList();
    // double left = 0;
    // double len = 0;
    // double top = 0;

    // int first = -1;
    // var fields = widget.model['formModel']['fields'];
    // //totalLines = (widget.model['formModel']['rows'] * 2).toDouble();
    // totalLines = widget.model['formModel']['rows'].toDouble();
    // for (var row = 0; row < widget.model['formModel']['rows']; row++) {
    //   for (var fld in fields) {
    //     if (fld['row'] == row) {
    //       len = _toLength(fld['colspan']);
    //       de1signItems.add((
    //         Rect.fromLTWH((left + fld['col'].toDouble()) * 2, row * 2, len, 2),
    //         Colors.blue,
    //         '${fld["label"]}',
    //         fld,
    //         DesignItemType.formField
    //       ));
    //     }
    //   }
    //}
  }

  @override
  Widget build(BuildContext context) {
    jsonBloc = BlocProvider.of<JsonBloc>(context);

    return BlocConsumer<DesignBloc, DesignState>(
      listener: (context, state) {
        if (state is DesignFieldChange) {
          if (state.fieldAction == FieldAction.addField) {
            var templ = getTemplate(JsonTemplate.formField);
            templ['name'] = state.fieldName;
            templ['label'] = state.fieldName;
            _addField(state.fieldName, templ);
            _buildFieldList();
            setState(() {});
          } else if (state.fieldAction == FieldAction.removeField) {
            _removeField(state.fieldName);
            _buildFieldList();
            setState(() {});
          }
          // } else if (state.fieldAction == FieldAction.selectField) {
          //   selectedField = state.fieldName;
          // } else if (state.fieldAction == FieldAction.unselectField) {
          //   selectedField = '';
          // }
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            ///
            /// Designer
            ///
            UiDesigner(
                itemRecords: designItems,
                model: widget.model,
                totalLines: totalLines,

                /// column, field
                modelChanged: (newModel, DesignItemType designItemType) {
                  _updateModel(newModel, designItemType);
                  _buildFieldList();
                  setState(() {});
                },
                uiDesignerType: UIdesignerType.list,
                key: UniqueKey()),

            if (showJson)
              OverlayPortal(
                overlayChildBuilder: (context) => Positioned(
                    top: 100,
                    left: 100,
                    child: Center(
                      child: JsonDesigner(
                          model: widget.model,
                          onButtonPressed: (String button, model) {
                            //_activeItem!.cargo = newModel;
                            if (button == "save") {}
                            _overlayController.hide();
                            showJson = false;
                            setState(() {});
                          },
                          key: UniqueKey()),
                    )),
                controller: _overlayController,
              ),
            // if (selectedField != '')
            //   ElevatedButton(
            //       child: Text("Remove Column"),
            //       onPressed: () {
            //         _removeField(selectedField);
            //         _buildItemList();
            //         setState(() {});
            //       })
          ],
        );
      },
    );
  }

  _buildFieldList() {
    double left = 0;
    double len = 0;
    double top = 0;

    int first = -1;
    var fields = widget.model['formModel']['fields'];
    //totalLines = (widget.model['formModel']['rows'] * 2).toDouble();
    totalLines = widget.model['formModel']['rows'].toDouble();
    for (var row = 0; row < widget.model['formModel']['rows']; row++) {
      for (var fld in fields) {
        if (fld['row'] == row) {
          len = _toLength(fld['colspan']);
          designItems.add((
            Rect.fromLTWH((left + fld['col'].toDouble()) * 2, row * 2, len, 2),
            Colors.blue,
            '${fld["label"]}',
            fld,
            DesignItemType.formField
          ));
        }
      }
    }
  }

  _updateModel(dynamic newModel, DesignItemType designItemType) {
    if (designItemType == DesignItemType.formField) {
      var fields = widget.model['formModel']['fields'];
      //totalLines = (widget.model['formModel']['rows'] * 2).toDouble();
      for (var i = 0; i < fields.length; i++) {
        if (fields[i]['name'] == newModel['name']) {
          fields[i] = newModel;
          jsonBloc.add(JsonBufferModelEvent(model: widget.model));
          break;
        }
      }
    } else if (designItemType == DesignItemType.Layout) {
      for (var fld in newModel) {
        print("name=${fld['name']}, row=${fld['row']}, col=${fld['col']}");
      }
      widget.model['formModel']['fields'] = newModel;
      jsonBloc.add(JsonBufferModelEvent(model: widget.model));
    }
  }

  _addField(String fieldName, Map templ) {
    bool found = false;
    var fields = widget.model['formModel']['fields'];
    for (var fld in fields) {
      if (fld['name'] == fieldName) {
        found = true;
      }
    }
    if (!found) {
      fields.add(templ);
    }
  }

  _removeField(String fieldName) {
    var fields = widget.model['formModel']['fields'];

    //for (var cl in ln['columns']) {
    for (var i = 0; i < fields.length; i++) {
      if (fields[i]['name'] == fieldName) {
        fields.removeAt(i);
        return;
      }
    }
  }

  _toLength(dynamic colspan) {
    if (colspan is String) {
      return (int.parse(colspan).toDouble()) * 2;
    } else {
      return colspan.toDouble() * 2;
    }
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   jsonBloc = BlocProvider.of<JsonBloc>(context);

  //   return Column(
  //     children: [
  //       ///
  //       /// Designer
  //       ///
  //       UiDesigner(
  //           itemRecords: designItems,
  //           model: widget.model,
  //           totalLines: totalLines,
  //           modelChanged: (newModel, DesignItemType designItemType) {
  //             _updateModel(newModel, designItemType);
  //           },
  //           uiDesignerType: UIdesignerType.form,
  //           key: UniqueKey()),
  //       if (showJson)
  //         OverlayPortal(
  //           overlayChildBuilder: (context) => Positioned(
  //               top: 100,
  //               left: 100,
  //               child: Center(
  //                 child: JsonDesigner(
  //                     model: widget.model,
  //                     onButtonPressed: (String button, newModel) {
  //                       //_activeItem!.cargo = newModel;
  //                       if (button == "save") {
  //                         _updateModel(newModel, DesignItemType.formField);
  //                       }
  //                       _overlayController.hide();
  //                       showJson = false;
  //                       setState(() {});
  //                     },
  //                     key: UniqueKey()),
  //               )),
  //           controller: _overlayController,
  //         ),
  //     ],
  //   );
  // }
