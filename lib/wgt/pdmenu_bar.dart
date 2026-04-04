import 'package:flutter/material.dart';
import 'json_designer.dart';
import 'popup_widget.dart';

class PdMenuBar extends StatefulWidget {
  final dynamic menuBar;
  final Function onChanged;

  PdMenuBar({required this.menuBar, required this.onChanged, super.key});

  @override
  State<PdMenuBar> createState() => _PdMenuBarState();
}

class _PdMenuBarState extends State<PdMenuBar> {
  var _overlayController;
  bool showPopup = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Text(widget.menuBar['label']),
          onTap: () {
            //_overlayController.show();
            showPopup = true;
            setState(() {});
          },
        ),
        if (showPopup)
          PopupWidget(
            child: JsonDesigner(
              model: widget.menuBar,
              onButtonPressed: (button, newModel) {
                if (button == "save") {
                  widget.onChanged(newModel);
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
          )
      ],
    );
  }
}

// class PdMenuItem extends StatefulWidget {
//   final dynamic menuBarItem;
//   final Function onChanged;

//   PdMenuItem({required this.menuBarItem, required this.onChanged, super.key});

//   @override
//   State<PdMenuItem> createState() => _PdMenuItemState();
// }

// class _PdMenuItemState extends State<PdMenuItem> {
//   var _overlayController;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           child: Text(widget.menuBarItem['label']),
//           onTap: () {
//             PopupWidget(
//               child: JsonDesigner(
//                 model: widget.menuBarItem,
//                 onButtonPressed: (button, newModel) {
//                   if (button == "save") {
//                     widget.onChanged(newModel);
//                     //state.json = newModel;
//                   }
//                   if (button == "cancel") {
//                     //Navigator.pop(context, false);
//                   }
//                   _overlayController.hide();
//                 },
//                 key: UniqueKey(),
//               ),
//               handler: (controller) {
//                 _overlayController = controller;
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
