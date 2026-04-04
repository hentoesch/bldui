import 'package:flutter/material.dart';
import 'pdmenu_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bldui/bloc/bloc.dart';

class PdMenuDesigner extends StatefulWidget {
  dynamic jsonModel;
  PdMenuDesigner({required this.jsonModel, super.key});
  @override
  State<PdMenuDesigner> createState() => _PdMenuDesignerState();
}

double height = 400;
var jsonBloc;

class _PdMenuDesignerState extends State<PdMenuDesigner> {
  @override
  Widget build(BuildContext context) {
    jsonBloc = BlocProvider.of<JsonBloc>(context);

    return Column(
      children: [
        Row(children: [
          for (var i = 0; i < widget.jsonModel['items'].length; i++)
            Container(
              padding: EdgeInsets.all(8),
              height: height,
              child: Column(children: [
                PdMenuBar(
                    menuBar: widget.jsonModel['items'][i],
                    onChanged: (newModel) {
                      widget.jsonModel['items'][i] = newModel;
                      setState(() {});
                    }),
                SizedBox(height: 8),
                for (var j = 0;
                    j < widget.jsonModel['items'][i]['items'].length;
                    j++)
                  PdMenuBar(
                      menuBar: widget.jsonModel['items'][i]['items'][j],
                      onChanged: (newModel) {
                        widget.jsonModel['items'][i]['items'][j] = newModel;
                        setState(() {});
                      }),
                ElevatedButton(
                    onPressed: () {
                      widget.jsonModel['items'][i]['items'].add({
                        "label": "newItem",
                        "routerLink": [
                          "PageLoader",
                          {"page": "new_page"}
                        ]
                      });
                      setState(() {});
                    },
                    child: Text("New Item"))
              ]),
            ),
        ]),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  jsonBloc.add(JsonPersistEvent(
                      eventType: EventType.UPDATE, model: widget.jsonModel));
                  Navigator.of(context).pop();
                },
                child: Text("Save")),
            ElevatedButton(
                onPressed: () {
                  widget.jsonModel['items']
                      .add({"label": "newMenu", "items": []});
                  setState(() {});
                },
                child: Text("New Menu")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
          ],
        )
      ],
    );
  }
}
