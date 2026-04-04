import 'package:bldui/bloc/json_bloc.dart';
import 'package:bldui/common/template.dart';
import 'package:flutter/material.dart';
import 'ui_designer.dart';
import 'json_designer.dart';
import 'package:bldui/common/types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bldui/bloc/bloc.dart';
import 'model_field_edit.dart';

class ListDesigner extends StatefulWidget {
  Map model;
  ListDesigner({required this.model, Key? key}) : super(key: key);

  @override
  State<ListDesigner> createState() => _ListDesignerState();
}

class _ListDesignerState extends State<ListDesigner> {
  var jsonBloc;

  var _overlayController = OverlayPortalController();
  double totalLines = 0;

  /// records for designer
  List<(Rect, Color, String, dynamic, DesignItemType)> designItems = [];
  //List<Item> designItems = [];
  bool showJson = false;
  var editModel = {};
  //String selectedField = '';
  @override
  void initState() {
    super.initState();
    _buildItemList();
  }

  @override
  Widget build(BuildContext context) {
    jsonBloc = BlocProvider.of<JsonBloc>(context);
    return BlocConsumer<DesignBloc, DesignState>(
      listener: (context, state) {
        if (state is DesignFieldChange) {
          if (state.fieldAction == FieldAction.addField) {
            var templ = getTemplate(JsonTemplate.listColumn);
            var para = widget.model['listModel']['paragraphs'];
            templ['name'] = state.fieldName;
            _addField(state.fieldName, templ);
            _buildItemList();
            setState(() {});
          } else if (state.fieldAction == FieldAction.removeField) {
            _removeField(state.fieldName);
            _buildItemList();
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
                  _buildItemList();
                  setState(() {});
                },
                uiDesignerType: UIdesignerType.list,
                key: UniqueKey()),
            Container(height: 32, child: Text('DataModel')),
            Container(
                height: 32,
                child: Row(children: [
                  ModelFieldEdit(
                    model: widget.model['dataModel'],
                    fieldName: "where",
                    width: 600,
                  ),
                  SizedBox(width: 8),
                  ModelFieldEdit(
                      model: widget.model['dataModel'],
                      fieldName: "linkField",
                      width: 400),
                ])),
            SizedBox(
              height: 8,
            ),
            Container(
                height: 32,
                child: Row(children: [
                  ModelFieldEdit(
                      model: widget.model['dataModel'],
                      fieldName: "order",
                      width: 600),
                  SizedBox(width: 8),
                  ModelFieldEdit(
                      model: widget.model['dataModel'],
                      fieldName: "group",
                      width: 400),
                  SizedBox(width: 8),
                  ModelFieldEdit(
                      model: widget.model['dataModel'], fieldName: "keyField"),
                ])),

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

  _buildItemList() {
    totalLines = 0;

    double left = 0;
    double len = 0;
    double top = 0;
    //List<(Rect, Color, String, dynamic, DesignItemType)> designItems = [];
    designItems = [];

    var para = widget.model['listModel']['paragraphs'];
    var paraCnt = 0;
    var lineCnt = 0;
    for (var p in para) {
      designItems.add((
        Rect.fromLTWH(left, top, 1, (2 * p['rows'].length).toDouble()),
        Colors.blue,
        'paragraph_$paraCnt',
        p,
        DesignItemType.listParagraph
      ));
      left += 1;
      lineCnt = 0;
      // lines
      for (var ln in p['rows']) {
        designItems.add((
          Rect.fromLTWH(left, top, 1, 2),
          Colors.green,
          'line_$lineCnt',
          ln,
          DesignItemType.listRow
        ));
        left += 1;
        for (var cl in ln['columns']) {
          len = _toWidth(cl['width']);
          designItems.add((
            Rect.fromLTWH(left, top, len, 2),
            Colors.grey,
            cl['name'],
            cl,
            DesignItemType.listColumn
          ));
          //left += (attributeData[i][1]['width'] / 10);
          left += len;
        }
        top += 2;
        lineCnt++;
        totalLines++;
      }
      paraCnt++;
    }
  }

  _addField(String fieldName, Map templ) {
    bool found = false;
    var cols;
    var para = widget.model['listModel']['paragraphs'];
    for (var p in para) {
      for (var ln in p['rows']) {
        cols = ln['columns'];
        for (var cl in ln['columns']) {
          if (cl['name'] == fieldName) {
            found = true;
          }
        }
      }
    }
    if (!found) {
      cols.add(templ);
    }
  }

  _removeField(String fieldName) {
    var para = widget.model['listModel']['paragraphs'];

    for (var p in para) {
      for (var ln in p['rows']) {
        //for (var cl in ln['columns']) {
        for (var i = 0; i < ln['columns'].length; i++) {
          if (ln['columns'][i]['name'] == fieldName) {
            ln['columns'].removeAt(i);
            return;
          }
        }
      }
    }
  }

  ///
  /// newModel: column or para[lines[columns]]
  ///
  _updateModel(newModel, DesignItemType designItemType) {
    var para = widget.model['listModel']['paragraphs'];
    int foundPos = -1;
    bool changed = false;
    if (designItemType == DesignItemType.listColumn) {
      for (var p in para) {
        // lines
        for (var ln in p['rows']) {
          int pos = 0;
          for (var cl in ln['columns']) {
            if (cl['name'] == newModel['name']) {
              //cl = newModel;
              foundPos = pos;
              break;
            }
            pos++;
          }
          if (foundPos >= 0) {
            ln['columns'][foundPos] = newModel;
            foundPos = -1;
            changed = true;
            break;
          }
        }
      }
    } else if (designItemType == DesignItemType.Layout) {
      changed = true;
      int paPos = 0;
      int lnPos = 0;
      int colPos = 0;
      for (paPos = 0; paPos < newModel.length; paPos++) {
        List row = [];
        // lines
        for (var lnPos = 0; lnPos < newModel[paPos].length; lnPos++) {
          List colList = [];
          for (colPos = 0; colPos < newModel[paPos][lnPos].length; colPos++) {
            var curCol = newModel[paPos][lnPos][colPos];
            colList.add(curCol);
          }
          para[paPos]['rows'][lnPos]['columns'] = colList;
          //row
          //for (var cl in ln['columns']) {}}}
        }
        //para[paPos]['rows'] = row;
      }
    }

    if (changed) {
      jsonBloc.add(JsonBufferModelEvent(model: widget.model));
    }
  }

  double _toWidth(String? px) {
    if (px == null || px == '') {
      return 8;
    } else {
      int i = int.parse(px.replaceAll('px', ''));
      return int.parse((i.toDouble() / 20).toStringAsFixed(0)).toDouble();
    }
  }
}
