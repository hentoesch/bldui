import 'package:flutter/material.dart';
import 'designer_wgts.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:dartlib/node.dart';
import 'package:bldui/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import "compound_designer.dart";
import 'pdmenu_designer.dart';
//import 'list_designer.dart';
//import 'form_designer.dart';

List<String> _validObjects = [
  "_list",
  "_form",
  "_menu",
  "_pdmenu",
  "_toolbar",
  "_dirlist",
  "_panel",
];

class DesignHandler extends StatefulWidget {
  final String designTarget;
  final TreeEntry<Node> node;
  const DesignHandler(
      {required this.designTarget, required this.node, super.key});

  @override
  State<DesignHandler> createState() => _DesignHandlerState();
}

class _DesignHandlerState extends State<DesignHandler> {
  String mnd = 'dir';
  String app = 'cdm';
  String wgt = 'sim_list';
  bool _isValid = false;
  var jsonBloc;
  @override
  void initState() {
    super.initState();
    wgt = widget.node.node.name;
    for (var obj in _validObjects) {
      if (wgt.endsWith(obj)) {
        _isValid = true;
      }
    }
    if (_isValid) {
      app = widget.node.parent!.parent!.node.name;
      mnd = _getMandant(widget.node.parent!.parent!.parent!.node.name);
    }
    //app = widget.node.parent.parent.name;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValid) {
      return Text("Invalid widget, no designer available");
    } else {
      return MultiBlocProvider(
        providers: [
          BlocProvider<JsonBloc>(
            key: UniqueKey(),
            create: (context) =>
                JsonBloc()..add(JsonGetDataEvent(mnd: mnd, app: app, wgt: wgt)),
          ),
          BlocProvider<DesignBloc>(
            create: (context) => DesignBloc(),
          ),
        ],
        child: BlocBuilder<JsonBloc, JsonState>(
          builder: (context, state) {
            if (!_isValid) {
              return Text("invalid Object: //");
            } else {
              if (state is JsonDataReady) {
                jsonBloc = BlocProvider.of<JsonBloc>(context);
                if (widget.designTarget.endsWith('_list')) {
                  //return ListDesigner(model: state.json, key: UniqueKey());
                  return CompoundDesigner(
                    designWidget:
                        ListDesigner(model: state.json, key: UniqueKey()),
                    onButtonPressed: (button, newModel) {
                      print("Button pressed: ");
                      if (button == "save") {
                        // persiset model
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pop(context, false);
                      }
                    },
                    model: state.json,
                  );
                } else if (widget.designTarget.endsWith('_form')) {
                  return CompoundDesigner(
                    designWidget:
                        FormDesigner(model: state.json, key: UniqueKey()),
                    onButtonPressed: (button, newModel) {
                      print("Button pressed: ");
                      if (button == "save") {
                        // persiset model
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pop(context, false);
                      }
                    },
                    model: state.json,
                  );
                } else if (widget.designTarget.endsWith('_pdmenu')) {
                  return PdMenuDesigner(jsonModel: state.json);
                }
                return JsonDesigner(
                  model: state.json,
                  onButtonPressed: (button, newModel) {
                    if (button == "save") {
                      jsonBloc.add(JsonPersistEvent(
                          eventType: EventType.UPDATE, model: newModel));

                      //state.json = newModel;
                    }
                    if (button == "cancel") {
                      Navigator.pop(context, false);
                    }
                  },
                  key: UniqueKey(),
                );
              }
            }
            return Text("Nada");
          },
        ),
      );
    }
  }

  String _getMandant(String longName) {
    String retval = 'dir';
    if (longName.startsWith("Blitz")) {
      retval = 'bli';
    }
    if (longName.startsWith("Johann")) {
      retval = 'jsa';
    }

    return retval;
  }
}

// class DesignHandler extends StatelessWidget {
//   final String designTarget;
//   final TreeEntry<Node> source;
//   const DesignHandler(
//       {required this.designTarget, required this.source, super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (designTarget.endsWith('_context_menu')) {
//       //return ContextMenuDesigner();
//     } else if (designTarget.endsWith('_list')) {
//       return ListDesigner();
//     } else if (designTarget.endsWith('_form')) {
//       return FormDesigner();
//     } else if (designTarget.endsWith('_toolbar')) {
//       //return ToolbarDesigner();
//     } else if (designTarget.endsWith('_dirlist')) {
//     } else if (designTarget.endsWith('_menu')) {
//       //return MenuDesigner();
//     }
//     return JsonDesigner(node: source);

//     //return Text('designTarget not found: $designTarget');
//   }
// }
