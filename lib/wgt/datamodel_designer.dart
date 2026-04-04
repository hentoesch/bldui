import 'package:flutter/material.dart';
import 'json_designer.dart';
import 'popup_widget.dart';
import 'package:bldui/common/template.dart' as tmpl;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bldui/bloc/bloc.dart';
import 'package:bldui/common/types.dart';
import 'model_field_edit.dart';

class DataModelDesigner extends StatefulWidget {
  Map model;
  DataModelDesigner({required this.model, super.key});

  @override
  State<DataModelDesigner> createState() => _DataModelDesignerState();
}

List<String> cols = ["tables", "fields"];

class _DataModelDesignerState extends State<DataModelDesigner> {
  bool showPopup = false;
  var _overlayController;
  var editMap = {};
  int selectedRow = 0;
  String selectedCol = "";
  var jsonBloc;
  var designBloc;

  Map<String, String?> _transform(map) {
    Map<String, String?> retval = {};
    for (var m in map.entries) {
      retval[m.key] = m.value;
    }
    return retval;
  }

  final double colWidth = 150;
  @override
  Widget build(BuildContext context) {
    jsonBloc = BlocProvider.of<JsonBloc>(context);
    designBloc = BlocProvider.of<DesignBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var hdr in cols)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ///
                /// title
                ///
                Container(width: colWidth, child: Text(hdr)),
                Divider(),
                //for (var map in widget.dataModel[hdr])
                for (var i = 0; i < widget.model['dataModel'][hdr].length; i++)
                  Row(children: [
                    Container(
                        width: colWidth,
                        child: InkWell(
                          child:
                              Text(widget.model['dataModel'][hdr][i]['name']),
                          onTap: () {
                            showPopup = true;
                            if (_overlayController != null)
                              _overlayController.show();
                            editMap = widget.model['dataModel'][hdr][i];
                            selectedRow = i;
                            selectedCol = hdr;
                            setState(() {});
                          },
                        )),
                    SizedBox(width: 8),

                    ///
                    /// delete table or field
                    ///
                    InkWell(
                      child: Icon(Icons.delete_forever),
                      onTap: () {
                        designBloc.add(DesignFieldChangeEvent(
                            fieldName: widget.model['dataModel'][hdr][i]
                                ['name'],
                            fieldAction: FieldAction.removeField));
                        widget.model['dataModel'][hdr].removeAt(i);

                        setState(() {});
                      },
                    ),
                    SizedBox(width: 8),

                    ///
                    /// add table or field
                    ///
                    InkWell(
                      child: Icon(Icons.add),
                      onTap: () {
                        designBloc.add(DesignFieldChangeEvent(
                            fieldName: widget.model['dataModel'][hdr][i]
                                ['name'],
                            fieldAction: FieldAction.addField));
                      },
                    ),
                    SizedBox(width: 8),
                    //for (var el in map.entries) Text("${el.key}: ${el.value}"),
                    //SizedBox(width: 8),
                  ]),
                InkWell(
                  child: Text("Add"),
                  onTap: () {
                    JsonTemplate whichTemplate = hdr == 'tables'
                        ? JsonTemplate.dataModelTable
                        : JsonTemplate.dataModelField;
                    widget.model['dataModel'][hdr]
                        .add(tmpl.getTemplate(whichTemplate));
                    setState(() {});
                  },
                ),
              ]),
            if (showPopup)
              PopupWidget(
                child: JsonDesigner(
                  model: editMap,
                  onButtonPressed: (button, newModel) {
                    if (button == "save") {
                      // Map<String, String?> mdl = newModel
                      //     .map((key, value) => MapEntry(key, value?.toString()));
                      // Map<String, String?> mdl = newModel.map((key, value) {
                      //   Map<String, String?> retval = {
                      //     key: value == null ? null : value.toString()
                      //   };
                      //   return retval;
                      // });
                      widget.model['dataModel'][selectedCol][selectedRow] =
                          _transform(newModel);
                      jsonBloc.add(JsonBufferModelEvent(model: widget.model));

                      setState(() {});
                      //widget.onChanged(newModel);
                      //state.json = newModel;
                    }
                    if (button == "cancel") {
                      //Navigator.pop(context, false);
                    }
                    showPopup = false;
                    _overlayController.hide();
                  },
                  key: UniqueKey(),
                ),
                handler: (controller) {
                  _overlayController = controller;
                },
              ),
          ],
        ),
      ),
    );
  }
}
