import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bldui/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartlib/node.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:json_editor_flutter/json_editor_flutter.dart';

class JsonDesigner extends StatefulWidget {
  Map model;
  Function onButtonPressed;

  JsonDesigner({required this.model, required this.onButtonPressed, Key? key})
      : super(key: key);

  @override
  State<JsonDesigner> createState() => _JsonDesignerState();
}

class _JsonDesignerState extends State<JsonDesigner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 800,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            width: 800,
            height: 700,
            child: JsonEditor(
                json: jsonEncode(widget.model),
                onChanged: (value) {
                  widget.model = value;
                  print('JsonEditor: $value');
                }),
          ),
          Align(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      child: Text("Save"),
                      onPressed: () {
                        widget.onButtonPressed("save", widget.model);
                      }),
                  ElevatedButton(
                      child: Text(
                        "Cancel",
                      ),
                      onPressed: () {
                        widget.onButtonPressed("cancel", {});
                        //Navigator.pop(context, false);
                      }),
                ]),
          ),
        ],
      ),
    );
  }
}
// class JsonDesigner extends StatefulWidget {
//   final TreeEntry<Node> node;
//   const JsonDesigner({required this.node, super.key});

//   @override
//   State<JsonDesigner> createState() => _JsonDesignerState();
// }

// List<String> validObjects = [
//   "_list",
//   "_form",
//   "_menu",
//   "_pdmenu",
//   "_toolbar",
//   "_page",
//   "_dirlist",
// ];

// class _JsonDesignerState extends State<JsonDesigner> {
//   String mnd = 'dir';
//   String app = 'cdm';
//   String wgt = 'sim_list';
//   bool _isValid = false;
//   @override
//   void initState() {
//     wgt = widget.node.node.name;
//     for (var obj in validObjects) {
//       if (wgt.endsWith(obj)) {
//         _isValid = true;
//       }
//     }
//     if (_isValid) {
//       app = widget.node.parent!.parent!.node.name;
//       mnd = _getMandant(widget.node.parent!.parent!.parent!.node.name);
//     }
//     //app = widget.node.parent.parent.name;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isValid) {
//       return Text("Invalid widget, no designer available");
//     } else {
//       return BlocProvider<JsonBloc>(
//         create: (context) =>
//             JsonBloc()..add(JsonGetDataEvent(mnd: mnd, app: app, wgt: wgt)),
//         child: BlocBuilder<JsonBloc, JsonState>(
//           builder: (context, state) {
//             if (state is JsonDataReady) {
//               return SizedBox(
//                 width: 800,
//                 height: 800,
//                 child: JsonEditor(
//                     json: jsonEncode(state.json),
//                     onChanged: (value) {
//                       print('JsonEditor: $value');
//                     }),
//               );
//             }
//             return Text("Nada");
//           },
//         ),
//       );
//     }
//   }

//   String _getMandant(String longName) {
//     String retval = 'dir';
//     if (longName.startsWith("Blitz")) {
//       retval = 'bli';
//     }
//     if (longName.startsWith("Johann")) {
//       retval = 'jsa';
//     }

//     return retval;
//   }
// }
